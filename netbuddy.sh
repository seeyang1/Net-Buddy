#!/bin/bash
sudo tcpdump -i eth0 -n -q > sniffed.txt &
sleep 30 
pid=$(ps -e | pgrep tcpdump)
echo $pid
sleep 1
sudo kill -2 $pid
head -n -1 sniffed.txt > sniff.txt
while :
do
	sudo tcpdump -i eth0 -n -q > sniffed.txt &
	./sifter.py sniff.txt
	sleep 30
	pid=$(ps -e | pgrep tcpdump)
	echo $pid
	sleep 1
	sudo kill -2 $pid
	head -n -1 sniffed.txt > sniff.txt
done
