#!/bin/bash
echo "--------------Firewall Settings----------------"

if [ "$1" == "BLOCK_IN_ICMP" ]
then	
	if [ $# == 2 ]
	then
		iptables -I INPUT -s $2 -p icmp -j DROP
        	iptables -I FORWARD -s $2 -i eth0 -p icmp -j DROP
		echo "Incoming ICMP packets from $2 are now blocked"
	else
		iptables -I INPUT -p icmp -j DROP	      	
		iptables -I FORWARD -i eth0 -p icmp -j DROP
		echo "Incoming ICMP packets are now blocked"
	fi
elif [ "$1" == "BLOCK_OUT_ICMP" ]
then
	if [ $# == 2 ]
	then
		iptables -I OUTPUT -d $2 -p icmp -j DROP
		iptables -I FORWARD -d $2 -i eth1 -p icmp -j DROP
		echo "Outgoing ICMP packets to $2 are now blocked"
	else
		iptables -I OUTPUT -p icmp -j DROP
                iptables -I FORWARD -i eth1 -p icmp -j DROP	
		echo "Outgoing ICMP packets are now blocked"
	fi
elif [ "$1" == "ALLOW_IN_ICMP" ]
then
	if [ $# == 2 ]
	then	
		iptables -I INPUT -s $2 -p icmp -j ACCEPT
       		iptables -I FORWARD -s $2 -i eth0 -p icmp -j ACCEPT
		echo "Incoming ICMP packets from $2 are now allowed"
	else
        	iptables -I INPUT -p icmp -j ACCEPT
       		iptables -I FORWARD -i eth0 -p icmp -j ACCEPT
		echo "Incoming ICMP packets are now allowed"
	fi
elif [ "$1" == "ALLOW_OUT_ICMP" ]
then
       	if [ $# == 2 ]
        then
                iptables -I OUTPUT -d $2 -p icmp -j ACCEPT
                iptables -I FORWARD -d $2 -i eth1 -p icmp -j ACCEPT
                echo "Outgoing ICMP packets to $2 are now allowed"
        else
                iptables -I OUTPUT -p icmp -j ACCEPT
                iptables -I FORWARD -i eth1 -p icmp -j ACCEPT     
                echo "Outgoing ICMP packets are now allowed"
        fi
elif [ "$1" == "BLOCK_IN_CONN" ]
then	
	echo "udp or tcp"
	read proto
	if [ $# == 3 ]
	then
		iptables -I FORWARD -i eth0 -s $3 -p $proto --dport $2 -j DROP
		iptables -I INPUT -i eth0 -s $3 -p $proto --dport $2 -j DROP
		echo "Incoming $proto connections on port $2 from $3 are now blocked"
	else
		iptables -I FORWARD -i eth0 -p $proto --dport $2 -j DROP
		iptables -I INPUT -p $proto --dport $2 -j DROP
		echo "Incoming $proto connections on port $2 are now blocked"
	fi
elif [ "$1" == "BLOCK_OUT_CONN" ]
then    
	echo "udp or tcp"
	read proto
	if [ $# == 3 ]
	then
		iptables -I FORWARD -i eth1 -d $3 -p $proto --dport $2 -j DROP
		iptables -I OUTPUT -d $3 -p $proto --dport $2 -j DROP
		echo "Outgoing $proto connections to $3 on port $2 are now blocked"
	else
		iptables -I FORWARD -i eth1 -p $proto --dport $2 -j DROP
		iptables -I OUTPUT -p $proto --dport $2 -j DROP
		echo "Outgoing $proto connections on port $2 are now blocked"
	fi
elif [ "$1" == "ALLOW_IN_CONN" ]
then 
	echo "udp or tcp"
        read proto
	if [ $# == 3 ]
	then 
		iptables -I FORWARD -i eth0 -s $3 -p $proto --dport $2 -j ACCEPT
		tables -I INPUT -s $3 -p $proto --dport $2 -j ACCEPT
		echo "Incoming $proto connections from $3 on port $2 are now allowed"
	else
		iptables -I FORWARD -i eth0 -p $proto --dport $2 -j ACCEPT
		iptables -I INPUT -p $proto --dport $2 -j ACCEPT
		echo "Incoming $proto connections on port $2 are now allowed"
	fi
elif [ "$1" == "ALLOW_OUT_CONN" ]
then 	
	echo "udp or tcp"
        read proto
	iptables -I FORWARD -i eth1 -p $proto --dport $2 -j ACCEPT
	iptables -I OUTPUT -p $proto --dport $2 -j ACCEPT
	echo "Outgoing $proto connections on port $2 are now allowed"
elif [ "$1" == "LIMIT_TRAFFIC" ]
then
	iptables -I FORWARD -s 10.8.0.5 -m limit --limit $2/minute --limit-burst $3 -j ACCEPT
	iptables -I FORWARD -s 10.8.0.5 -j DROP
	echo "Traffic coming to router is now limited"
elif [ "$1" == "RESET" ]
then
	iptables -F 
	iptables -P INPUT ACCEPT
	iptables -P OUTPUT ACCEPT
	echo "Firewall rules are now reset"
elif [ "$1" == "SHOW_IPTABLES" ]
then
	iptables -t filter -L -n
elif [ "$1" == "SAVE" ]
then 	
	/sbin/iptables-save
	echo "current settings are saved"
elif [ "$1" == "STOP_ARP" ]
then
	arptables -A INPUT -s $2 -j DROP
	arp -d $2
	echo "ARP packets from $2 are now blocked"	
else
	echo """Commands available - Type these commands in the arguments
	1) BLOCK_IN_ICMP
	2) BLOCK_IN_ICMP source-ip
	3) BLOCK_OUT_ICMP 
	4) BLOCK_OUT_ICMP destination-ip
	5) ALLOW_IN_ICMP
	6) ALLOW_IN_ICMP source-ip
	7) ALLOW_OUT_ICMP
	8) ALLOW_OUT_ICMP destination-ip
	9) BLOCK_IN_CONN port||port-range
	10)BLOCK_IN_CONN port||port-range source-ip
	11)BLOCK_OUT_CONN port||port-range
	12)BLOCK_OUT_CONN port||port-range destination-ip 
	13)ALLOW_IN_CONN port||port-range
	14)ALLOW_IN_CONN port||port-range source-ip
	15)ALLOW_OUT_CONN port||port-range
	16)LIMIT_TRAFFIC limit_allowed/min limit_burst
	17)STOP_ARP source-ip
	18)SAVE 
	19)RESET
	19)SHOW_IPTABLES
	"""
fi
