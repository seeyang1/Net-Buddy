#!/usr/bin/env python3
import sys
import re
import time

start_time = time.time()
file = str(sys.argv[1])
f = open(file, "r")
packets=[]
for line in f:
    x = re.split("\s", line)
    source = x[2]
    destination = x[4]
    protocol = x[5]
    if re.search("10.0.2.15", source):
        #print('found home ip',source)
        y = re.split('\.',source)
        source = y[0]+'.'+y[1]+'.'+y[2]+'.'+y[3]
        port = y[4]
        z = re.split('\.',destination)
        destination = z[0]+'.'+z[1]+'.'+z[2]+'.'+z[3]
    else:
        y = re.split('\.',destination)
        destination = y[0]+'.'+y[1]+'.'+y[2]+'.'+y[3]
        port = y[4]
        z = re.split('\.',source)
        source = z[0]+'.'+z[1]+'.'+z[2]+'.'+z[3]
    #print(source, destination, protocol)
    packets.append((source, destination, protocol, port))
print(packets)
print("--- %s seconds ---" % (time.time()-start_time))
f.close();
