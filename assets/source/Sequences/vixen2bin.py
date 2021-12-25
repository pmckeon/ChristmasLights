import sys
import csv

with open(sys.argv[1], newline='') as vixenfile:
    vixencsv = csv.reader(vixenfile)
    fbdata = open(sys.argv[1] + '.bin', 'wb')
    for row in vixencsv:
        data = 0
        for i in range(8): # write channel 1-8
            bit = int(row[i])
            if(bit > 0):
                data |= (1 << i)
        fbdata.write(data.to_bytes(1, byteorder ='big'))
        data = 0
        for i in range(8,16): # write channel 9-16
            bit = int(row[i])
            if(bit > 0):
                data |= (1 << (i-8))
        fbdata.write(data.to_bytes(1, byteorder ='big'))
    fbdata.close()
