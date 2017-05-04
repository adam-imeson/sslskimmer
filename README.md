# sslskimmer

## Instructions

You're going to need to install dnspython and arpspoof.  You also need to set your wifi card to promiscuous mode and ensure that /proc/sys/net/ipv4/ip_forward is equal to 1.  I've only tested this on Linux.

sslstrip uses port 10000.  You can change this by editing a few files if necessary.

skim.py is the attack script.  It sets up the DNS proxy, runs sslstrip, and begins sniffing packets and checking fingerprints with fingerprintls.  If fingerprintls matches a fingerprint that you've listed in targets.json, skim.py launches an instance of arpspoof targeting that fingerprint's IP address, redirecting the user's traffic to your machine so that sslstrip can do what it does.
