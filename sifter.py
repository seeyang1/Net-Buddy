#!/usr/bin/env python3

#sudo code:
#open pcap file
#create a new file, B, to store the new data in
#while loop to read every line
#tons of if statements that find the text we need
#if statements will write the data we need into file B
#after if statement is done CLOSE THE FILE!!!!!
#close file B 
#be on with your day

f = open("abc.txt", "r")
#data = open("data.txt","w")
while f:  
    line = f.readline()
    #sort through the line and extract source and destination IPs

f.close();

