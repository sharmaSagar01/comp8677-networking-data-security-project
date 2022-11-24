# Implemented ARP sppofing using scap

# import all the modules
import scapy.all as scapy
import python_arptable
from python_arptable import ARPTABLE

# Getting the MAC address
def mac(ipadd):
# requesting arp packets from the IP address
# if it's wrong then will throw error
        arp_request = scapy.ARP(pdst=ipadd)
        br = scapy.Ether(dst="ff:ff:ff:ff:ff:ff")
        arp_req_br = br / arp_request
#       print(arp_req_br)
        list_1 = scapy.srp(arp_req_br, timeout=5,
                                        verbose=False)[0]
#       print(list_1)
        return list_1[0][1].hwsrc

# taking interface of the system as an argument
# to sniff packets inside the network
def sniff(interface):
        # store=False tells sniff() function
        # to discard sniffed packets
        scapy.sniff(iface=interface,filter="tcp and src host 10.9.0.6 and dst 10.9.0.5", store=False,
                                prn=process_sniffed_packet)


# defining function to process sniffed packet
def process_sniffed_packet(packet):
	print(packet.show())
	mac_server = None
	for arp in ARPTABLE:
		if arp['IP address'] == packet[scapy.IP].src:
			mac_server = arp['HW address']
        #mac_server = mac(packet[scapy.IP].src)
	if packet[scapy.Ether].src != mac_server:
		print(packet[scapy.Ether].src)
		print(mac_server)
		print('Spoof attack from this MAC address ' + str(packet[scapy.Ether].src))
		print('This attacker can run remote commands on your shell.')
		#print('Packets sent by attacker: ', packet[])
	else:
		print('Packet from Trusted server')

# machine interface is "eth0", sniffing the interface
sniff("enp0s3")

