#!/usr/bin/env python3
import sys
import re
import os
from collections import Counter

file = str(sys.argv[1])
f = open(file, "r")
packets=[]
homeIP="10.26.86.237"
for line in f:
    x = re.split("\s", line)
    if x[1]!="IP" or len(x)>8 or x[5]=="ip-proto-6":
        continue;
    source = x[2]
    destination = x[4]
    protocol = x[5]
    if x[5]=='':
        protocol = x[6]
        protocol = protocol [2:]
    if re.search("UDP", protocol):
        protocol=protocol.rstrip(protocol[-1])
    if re.search(homeIP, source):
        y = re.split('\.',source)
        if len(y)<5:
            continue
        source = y[0]+'.'+y[1]+'.'+y[2]+'.'+y[3]
        port = y[4]
        z = re.split('\.',destination)
        destination = z[0]+'.'+z[1]+'.'+z[2]+'.'+z[3]
    else:
        y = re.split('\.',destination)
        if len(y)<5:
            continue
        destination = y[0]+'.'+y[1]+'.'+y[2]+'.'+y[3]
        port = y[4]
        port=port.rstrip(port[-1])
        z = re.split('\.',source)
        source = z[0]+'.'+z[1]+'.'+z[2]+'.'+z[3]
    packets.append((source,destination,protocol,port))
newList=Counter(packets).most_common()
for i in newList:
    sqlLine=i[0][0]+"','"+i[0][1]+"','"+i[0][2]+"','"+i[0][3]+"','"+str(i[1])+"'"
    os.system("mysql --host=net-buddy.mysql.database.azure.com --user=nbseniordesign --password=\"password\" -e \"use packet_sniffing; INSERT INTO nettraffic (Source,Destination,Protocol,Port,Count) VALUES (\'"+sqlLine+");\"")
f.close();
