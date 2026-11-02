# ========================================================================
# DAY 17 - Wireshark Foundations + tcpdump
# Date: November 02, 2026
# ========================================================================

sudo tcpdump -i any -c 50   #(-i any = all network interfaces; -c 50 = stop after 50 packets)
sudo tcpdump -i any port 53 -c 20   #(only DNS traffic)
sudo tcpdump -i any -c 100 -w capture.pcap  #(-w saves the packets to a file)
sudo tcpdump -r capture.pcap   #(-r reads the packets from a file)
sudo tcpdump -i any -c 50 -n   #(-n = don't resolve hostnames)
sudo tcpdump -i any -c 50 -nn   #(-nn = don't resolve hostnames or ports)
sudo tcpdump -i any -c 50 -nn -v   #(-v = verbose output)
sudo tcpdump -i any -c 50 -nn -vv   #(-vv = very verbose output)
sudo tcpdump -i any -c 50 -nn -vv -X   #(-X = show packet contents in hex and ASCII)

# ========================================================================

# I'll use tcpdump instead of wireshark for packet analysis on a server with no screen.
# The commands above will help me capture and analyze network traffic effectively.