#steps that need to be done:
#open file->read line by line-> find pattern of where to extract text from 
#in order to know where to extract from have to first save a pcap and see what it gives
#from there we have to look at the plain text and see what we can gather from it
#after that headache, we have to write what we find in another file so that it can be sent to server
#-------------------------------------------------------------------------------------------#


#sudo code:
#open pcap file
#create a new file, B, to store the new data in
#while loop to read every line
#tons of if statements that find the text we need
#if statements will write the data we need into file B
#after if statement is done CLOSE THE FILE!!!!!
#close file B 
#be on with your day

traffic = open("abc.txt", "r");
#data = open("data.txt","w");
while traffic: 
    line = traffic.readline();
    #place if statements that will sift through the pcap
    #here we have to look at the packets and then store ip addresses(?)
    #then count how many times the ip addresses occur and if they're inbound or outbound
    if line = "":
        break
traffic.close();
data.close();

