arr = bytearray(2 * 1024)

arr[200] = 0x76

with open("eeprom.bin", 'wb') as file:
    file.write(arr)


