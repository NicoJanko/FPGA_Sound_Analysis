import serial
import serial
import struct

from collections import deque
import sys
import numpy as np
from PyQt6 import QtCore
from PyQt6.QtWidgets import QWidget, QVBoxLayout,QHBoxLayout, QMainWindow, QApplication, QPushButton,QComboBox, QLabel

from matplotlib.figure import Figure
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar
#COM4 win /dev/ttyUSB1 lin

POSSIBLE_COM = ['COM4','/dev/ttyUSB1']

class SerialReader(QtCore.QThread):
    data_received = QtCore.pyqtSignal(float,float,float,int)
    def __init__(self,baud=115200, parent = None):
        super().__init__(parent)
        self.baud = baud
        self.running=False
        self.paused = False

    def update_port(self,com_port):
        self.port = com_port
        if not self.running :
            try:
                self.ser = serial.Serial(self.port, baudrate=self.baud,timeout=0)
                print("port ok")
                self.running = True
            except:
                print("port not ok")
                self.running = False
    def getStatus(self):
        return self.running
    
    def pause(self):
        self.paused = True

    def resume(self):
        self.paused = False

    def run(self):
        print("launch run")
        while self.running:
            if self.paused:
                self.msleep(100)
                continue
            #start_list = list(self.ser.read(50))
            #print(f'First 50 bytes : { start_list}')
            start = self.ser.read(1)
            #print(f"start {start}")
            #if start != b'':
                #print(f"start {start}")
            if start == b'\xaa':

                #anlog_raw1 = self.ser.read(1)
                #anlog_raw2 = self.ser.read(1)
                anlog_raw = self.ser.read(2)
                mean_raw = self.ser.read(2)
                std_raw = self.ser.read(2)
                
                dig_start = self.ser.read(1)
                
                dig_raw = self.ser.read(1)
                #print(f"""
#start 0: {ord(start)},
#analog_raw 1: {ord(anlog_raw1)},
#analog_raw 2: {ord(anlog_raw2)},
#dig_start 3: {ord(dig_start)},
#dig_raw 4: {ord(dig_raw)}
#""")
                if len(anlog_raw) ==2:
                    #print(f"raw aa {anlog_raw}")
                    try:
                        adv_val = struct.unpack('>H',anlog_raw)[0]
                        #adv_val = (adc_val/4095.0)*3.3
                    except:
                        adv_val = np.nan
                    try:
                        mean_val = struct.unpack('>H',mean_raw)[0]
                        #mean_val = (mean_val/4095.0)*3.3
                    except:
                        mean_val = np.nan
                    try:
                        std_val = struct.unpack('>H',std_raw)[0]
                        #std_val = np.sqrt(std_val)
                    except:
                        std_val = np.nan

                    
                    #print(f'adv_val {adv_val}')
                    self.data_received.emit(adv_val,mean_val,std_val,-1)
                if dig_start == b'\xbb':
                    #print(f"stop {stop}")
                    #print(f"dig_raw {dig_raw}")
                    try:
                        dig_val = ord(dig_raw)
                        self.data_received.emit(-1,dig_val)
                    except TypeError:
                        dig_val = np.nan
                        self.data_received.emit(-1,-1,-1,dig_val)
                    #print(f"dig_val {dig_val}")
                    #self.data_received.emit(-1,dig_val)
                    #raw = self.ser.read(1)
                    #print(f"raw bb {raw}")
            #elif start == b'\xbb':
                #raw = self.ser.read(1)
                #print(f"raw bb {raw}")
                #if len(raw) ==1:
                    #dig_val = raw[0] & 0x01
                    #
            #else:
                #if start != b'':
                    #print(f"not aa or bb {start}")
    def stop(self):
        self.running = False
        try:
            self.ser.close()
            self.wait()
        except:
            return

class Visualizer(QWidget):
    def __init__(self,analog=False,y_lim=(-0.3,1.3), parent = None):
        super().__init__(parent)
        self.analog = analog
        self.canvas = FigureCanvas(Figure(figsize=(10,20)))
        self.ax1 = self.canvas.figure.add_subplot(111)
        self.nav_toolbar = NavigationToolbar(self.canvas, self)

        self.ax1.set_ylim(y_lim[0],y_lim[1])

        self.data = deque([0]*10000,maxlen=10000)
        self.pos_threshold = deque([0]*10000,maxlen=10000)
        self.neg_threshold  = deque([0]*10000,maxlen=10000)


        self.line, = self.ax1.plot(self.data)
        self.pos_lin, = self.ax1.plot(self.pos_threshold, color='red', linestyle='--')
        self.neg_lin, = self.ax1.plot(self.neg_threshold, color='green', linestyle='--')


        layout = QVBoxLayout()
        layout.addWidget(self.canvas)
        layout.addWidget(self.nav_toolbar)
        self.setLayout(layout)

        self.timer = QtCore.QTimer()
        self.timer.timeout.connect(self.update_plot)
        self.timer.start(60)

    def update_plot(self):
        self.line.set_ydata(self.data)
        self.line.set_xdata(range(len(self.data)))
        self.pos_lin.set_ydata(self.pos_threshold)
        #self.neg_lin.set_ydata(self.neg_threshold)

        self.ax1.relim()
        self.ax1.autoscale_view()

        self.canvas.draw()

    def add_data(self, analog_val,mean_val, std_val, dig_val):
        if self.analog:
            if analog_val >=0:
                #print(f"addind adv_val {analog_val}")
                self.data.append(analog_val)
                print(f" value : {analog_val} mean_val {mean_val},true_maean {np.mean(list(self.data)[-50:])} std_val {std_val}")
                self.pos_threshold.append(mean_val+2*std_val)
                self.neg_threshold.append(mean_val-2*std_val)
        else:
            if dig_val >=0:
                #print(f"addind dig_val {dig_val}")
                self.data.append(dig_val)

        

class App(QMainWindow):
    def __init__(self, parent = None):
        super().__init__(parent)
        self.analog_plot = Visualizer(analog=True, y_lim=(2800,2900))
        self.dig_plot = Visualizer(analog=False, y_lim=(-0.3,1.3))
        self.central_widget = QWidget()
        self.setCentralWidget(self.central_widget)
        self.layout_ = QVBoxLayout()
        self.connect_layout = QHBoxLayout()
        self.connect_button = QPushButton("Connect")
        self.connect_button.clicked.connect(self.launch_reader)
        self.pause_button = QPushButton("Pause")
        self.pause_button.setCheckable(True)
        self.pause_button.clicked.connect(self.toggle_pause)


        self.status = QLabel()
        self.status.setFixedSize(20,20)
        self.status.setStyleSheet("background-color: red; border: 1px solid black;")

        self.com_combobox = QComboBox()
        self.com_combobox.addItems(POSSIBLE_COM)

        self.connect_layout.addWidget(self.status)
        self.connect_layout.addWidget(self.connect_button)
        self.connect_layout.addWidget(self.com_combobox)
        self.connect_layout.addWidget(self.pause_button)
        self.layout_.addLayout(self.connect_layout)

        self.layout_.addWidget(self.analog_plot)
        self.layout_.addWidget(self.dig_plot)
        self.reader = SerialReader()
        self.reader.data_received.connect(self.analog_plot.add_data)
        self.reader.data_received.connect(self.dig_plot.add_data)


        self.central_widget.setLayout(self.layout_)
    
    def launch_reader(self):
        if not self.reader.isRunning():
            self.reader.update_port(self.com_combobox.currentText())
            if self.reader.getStatus():
                self.reader.start()
                self.status.setStyleSheet("background-color: green; border: 1px solid black;")
        

    def toggle_pause(self):
        if self.pause_button.isChecked():
            self.reader.pause()
            self.pause_button.setText("Resume")
        else:
            self.reader.resume()
            self.pause_button.setText("Pause")

    def closeEvent(self, event):
        self.reader.stop()
        event.accept()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    main = App()
    main.resize(800,600)
    main.show()
    sys.exit(app.exec())

