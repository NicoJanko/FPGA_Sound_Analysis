import serial
import serial
import struct

from collections import deque
import sys

from PyQt6 import QtCore
from PyQt6.QtWidgets import QWidget, QVBoxLayout, QMainWindow, QApplication

from matplotlib.figure import Figure
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
#COM4 win /dev/ttyUSB1 lin

class SerialReader(QtCore.QThread):
    data_received = QtCore.pyqtSignal(float,int)
    def __init__(self,port='/dev/ttyUSB1',baud=115200, parent = None):
        super().__init__(parent)
        self.ser = serial.Serial(port, baudrate=baud,timeout=0)
        self.running = True
    def run(self):
        while self.running:
            start = self.ser.read(1)
            #if start != b'':
                #print(f"start {start}")
            if start == b'\xaa':

                anlog_raw = self.ser.read(2)
                
                dig_raw = self.ser.read(1)
                
                stop = self.ser.read(1)
                #print(f"""
#start 0: {start},
#analog_raw 1-2: {anlog_raw},
#dig_raw 3: {dig_raw},
#stop 4: {stop}
#""")
                if len(anlog_raw) ==2:
                    #print(f"raw aa {anlog_raw}")
                    adc_val = struct.unpack('>H',anlog_raw)[0]
                    adv_val = (adc_val/4095.0)*3.3
                    #print(f'adv_val {adv_val}')
                    self.data_received.emit(adv_val,-1)
                if stop == b'\xbb':
                    #print(f"stop {stop}")
                    #print(f"dig_raw {dig_raw}")
                    dig_val = dig_raw[0] & 0x01
                    #print(f"dig_val {dig_val}")
                    self.data_received.emit(-1,dig_val)
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
        self.ser.close()
        self.wait()

class Visualizer(QWidget):
    def __init__(self,analog=False,y_lim=(-0.3,1.3), parent = None):
        super().__init__(parent)
        self.analog = analog
        self.canvas = FigureCanvas(Figure(figsize=(10,20)))
        self.ax1 = self.canvas.figure.add_subplot(111)

        self.ax1.set_ylim(y_lim[0],y_lim[1])

        self.data = deque([0]*10000,maxlen=10000)


        self.line, = self.ax1.plot(self.data)


        layout = QVBoxLayout()
        layout.addWidget(self.canvas)
        self.setLayout(layout)

        self.timer = QtCore.QTimer()
        self.timer.timeout.connect(self.update_plot)
        self.timer.start(60)

    def update_plot(self):
        self.line.set_ydata(self.data)
        self.line.set_xdata(range(len(self.data)))

        self.ax1.relim()
        self.ax1.autoscale_view()

        self.canvas.draw()

    def add_data(self, analog_val, dig_val):
        if self.analog:
            if analog_val >=0:
                #print(f"addind adv_val {analog_val}")
                self.data.append(analog_val)
        else:
            if dig_val >=0:
                #print(f"addind dig_val {dig_val}")
                self.data.append(dig_val)

class App(QMainWindow):
    def __init__(self, parent = None):
        super().__init__(parent)
        self.analog_plot = Visualizer(analog=True, y_lim=(0,100))
        self.dig_plot = Visualizer(analog=False, y_lim=(-0.3,1.3))
        self.central_widget = QWidget()
        self.setCentralWidget(self.central_widget)
        self.layout_ = QVBoxLayout()
        
        self.layout_.addWidget(self.analog_plot)
        self.layout_.addWidget(self.dig_plot)
        self.reader = SerialReader()
        self.reader.data_received.connect(self.analog_plot.add_data)
        self.reader.data_received.connect(self.dig_plot.add_data)
        self.reader.start()

        self.central_widget.setLayout(self.layout_)
    def closeEvent(self, event):
        self.reader.stop()
        event.accept()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    main = App()
    main.resize(800,600)
    main.show()
    sys.exit(app.exec())

