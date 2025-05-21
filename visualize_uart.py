import serial
import struct
import matplotlib.pyplot as plt
from collections import deque

# Config
PORT = '/dev/ttyUSB1'     
BAUD = 115200
BUFFER_SIZE = 1000         # number of points to display
ADC_BITS = 12             # XADC is 12-bit
VREF = 3.3                # Voltage reference for scaling

print('Connectnig to the serial')
ser = serial.Serial(PORT, baudrate=BAUD, timeout=1)

print('Setup Plot')
plt.ion()
fig, ax = plt.subplots()
data_buffer = deque([0]*BUFFER_SIZE, maxlen=BUFFER_SIZE)
line, = ax.plot(data_buffer)
ax.set_ylim(1.5, 2.0)
ax.set_title("Live ADC Signal")
ax.set_xlabel("Sample")
ax.set_ylabel("ADC Value (0–4095)")

print("Starting real-time plot. Press Ctrl+C to stop.")
data = 0
true_data = 0
corrupted_data = 0
try:
    while True:
        # Read bytes until we find the sync byte 0xAA
        start = ser.read(1)
        data += 1
        if start == b'\xAA':
            raw = ser.read(2)
            if len(raw) == 2:
                true_data +=1
                adc_val = struct.unpack('>H', raw)[0]
                #print(struct.unpack('>H', raw)[0])
                adv_val = (adc_val / 4095.0) * 3.3  # MSB first
                data_buffer.append(adv_val)

                line.set_ydata(data_buffer)
                line.set_xdata(range(len(data_buffer)))
                ax.relim()
                ax.autoscale_view()
                plt.pause(0.001)
            else:
                print("No data")
        else:
            corrupted_data +=1

        print(f"""
True Data : {(round(true_data/data,2)*100)}%
Corrupted Data {(round(corrupted_data/data,2)*100)}%
""", end='\r',flush=True)
except KeyboardInterrupt:
    print("\nStopped by user.")
finally:
    ser.close()