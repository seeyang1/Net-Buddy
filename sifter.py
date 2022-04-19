#!/usr/bin/env python3
import sys
import re
import time
import os
from collections import Counter

start_time = time.time()
file = str(sys.argv[1])
f = open(file, "r")
packets=[]
for line in f:
    x = re.split("\s", line)
    if x[1]!="IP":
        continue;
    source = x[2]
    destination = x[4]
    protocol = x[5]
    if re.search("UDP", protocol):
        protocol=protocol.rstrip(protocol[-1])
    if re.search("10.0.2.15", source):
        y = re.split('\.',source)
        source = y[0]+'.'+y[1]+'.'+y[2]+'.'+y[3]
        port = y[4]
        z = re.split('\.',destination)
        destination = z[0]+'.'+z[1]+'.'+z[2]+'.'+z[3]
    else:
        y = re.split('\.',destination)
        destination = y[0]+'.'+y[1]+'.'+y[2]+'.'+y[3]
        port = y[4]
        port=port.rstrip(port[-1])
        z = re.split('\.',source)
        source = z[0]+'.'+z[1]+'.'+z[2]+'.'+z[3]
    packets.append((source, destination, protocol, port))
newList=Counter(packets).most_common()
for i in newList:
    sqlLine=i[0][0]+"','"+i[0][1]+"','"+i[0][2]+"','"+i[0][3]+"','"+str(i[1])+"'"
    os.system("mysql --host=net-buddy.mysql.database.azure.com --user=nbseniordesign --password=\"j7Zp4wohzfR9n3\" -e \"use packet_sniffing; INSERT INTO netTraffic VALUES (\'"+sqlLine+");\"")
print("--- %s seconds ---" % (time.time()-start_time))
f.close();
