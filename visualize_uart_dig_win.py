import serial
import struct
import matplotlib.pyplot as plt
from collections import deque

# Config
PORT = 'COM4'     
BAUD = 115200
BUFFER_SIZE = 1000         # number of points to display
ADC_BITS = 12             # XADC is 12-bit
VREF = 3.3                # Voltage reference for scaling

print('Connectnig to the serial')
ser = serial.Serial(PORT, baudrate=BAUD, timeout=1)

print('Setup Plot')
plt.ion()
fig, ax1 = plt.subplots()
data_analog_buffer = deque([0]*BUFFER_SIZE, maxlen=BUFFER_SIZE)
data_dig_buffer = deque([0]*BUFFER_SIZE, maxlen=BUFFER_SIZE)

line_dig, = ax1.plot(data_dig_buffer)
ax1.set_ylim(-1, 2)
ax1.set_title("Analog Signal")



print("Starting real-time plot. Press Ctrl+C to stop.")
data = 0
true_data = 0
corrupted_data = 0
try:
    while True:
        # Read bytes until we find the sync byte 0xAA
        start = ser.read(1)
        data += 1
        if start == b'\xBB':
            bit = ser.read(1)
            if len(bit) ==1 :
                mic_val = bit[0] & 0x01
                print(mic_val)
                data_dig_buffer.append(mic_val)
                line_dig.set_ydata(data_dig_buffer)
                line_dig.set_xdata(range(len(data_dig_buffer)))
                ax1.relim()
                ax1.autoscale_view()
                plt.pause(0.00001)
        else:
            corrupted_data +=1

        #print(f"""
#True Data : {(round(true_data/data,2)*100)}%
#Corrupted Data {(round(corrupted_data/data,2)*100)}%
#""", end='\r',flush=True)
except KeyboardInterrupt:
    print("\nStopped by user.")
finally:
    ser.close()