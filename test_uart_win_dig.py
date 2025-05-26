import serial
import struct


print("begin")
ser = serial.Serial('COM4', 115200, timeout=1)
print('lauching data read')

try:
    while True:
        # Read bytes until we find the sync byte 0xAA
        start = ser.read(1)
        print(start)
        data = ser.read(1)
        if len(data) == 1:
                print(f"ADC Value: {hex(data[0])}")            
        else:
            print("Timeout waiting for 2nd + 3rd byte")
except KeyboardInterrupt:
    print("Stopped.")
finally:
    ser.close()
