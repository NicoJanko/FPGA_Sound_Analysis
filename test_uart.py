import serial
import struct


print("begin")
ser = serial.Serial('/dev/ttyUSB1', 115200, timeout=1)
print('lauching data read')

try:
    while True:
        # Read bytes until we find the sync byte 0xAA
        start = ser.read(1)
        if start == b'\xAA':
            data = ser.read(2)
            if len(data) == 2:
                val = struct.unpack('>H', data)[0]
                if val <= 4095:
                    print(f"ADC Value: {val}")
                else:
                    print(f"Corrupted Value (out of range): {val}")
                    raw = ser.read(3)
                    print([hex(b) for b in raw])
                    
            else:
                print("Timeout waiting for 2nd + 3rd byte")
except KeyboardInterrupt:
    print("Stopped.")
finally:
    ser.close()
