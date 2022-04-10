sudo tcpdump -i eth0 -n > sniffed.txt;
head -n -1 sniffed.txt > sniff.txt
./sifter.py sniff.txt;
