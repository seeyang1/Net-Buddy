#!/usr/bin/env python3
import sys

file = str(sys.argv[1])
packets=[]
temp=""
temp2=""
pFlag = False
iFlag = False
carrotFlag = False
f = open(file, "r")
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
    packets.append((temp,temp2))
    temp=""
    temp2=""
print("packet tuples:" , packets)
f.close();


#notes and to do list:
#obug(?) where last element in the list of tuples is empty. This occurs in every file we check
#should look at having the script take as input a txt file so that file being read isn't hard coded
