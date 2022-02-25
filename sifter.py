#!/usr/bin/env python3

source=[]
destination=[]
temp=""
temp2=""
pFlag = False
iFlag = False
carrotFlag = False
f = open("testLine.txt", "r")
#data = open("data.txt","w")
for line in f:
    for character in line:
        if character == "I":
            iFlag = True
        if character == "P":
            pFlag = True
        if character ==">":
            pFlag = False
            iFlag = False
            carrotFlag = True
        if character == ":":
            carrotFlag = False
        if pFlag and iFlag:
            temp = temp+character
        if carrotFlag:
            temp2 = temp2+character
    temp=temp.lstrip("P ")
    temp2=temp2.lstrip("> ")
    #print(temp)
    #print(temp2)
    source.append(temp)
    destination.append(temp2)
    temp=""
    temp2=""
print("source:" , source)
print("destination:",destination)
f.close();
