#!/bin/bash
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


# ========================================================================
# DAY 18 - Hydra + fail2ban (Attack and Defence)
# Date: November 02, 2026
# ========================================================================

#!/bin/bash
# Day 18: Hydra + fail2ban (Attack and Defence) on Kali Linux

# 1. Update package lists and install OpenSSH server, Hydra, and fail2ban
sudo apt update && sudo apt install -y openssh-server hydra fail2ban

# 2. Enable and start the SSH service
sudo systemctl enable --now ssh

# 3. Create a throwaway test user for the SSH brute-force lab
sudo adduser testuser

# 4. Verify the new user account exists
id testuser

# 5. Create a wordlist containing weak passwords and the valid password
printf "password\n123456\nqwerty\nletmein\nsunshine123\n" > /tmp/test-passwords.txt

# 6. Stop fail2ban temporarily to observe an undefended brute-force attack
sudo systemctl stop fail2ban

# 7. Run Hydra against the local SSH server to crack the weak password
hydra -l testuser -P /tmp/test-passwords.txt ssh://127.0.0.1 -t 4 -V

# 8. Inspect the failed login entries recorded in /var/log/auth.log
sudo grep "Failed password" /var/log/auth.log | tail

# 9. Copy default fail2ban configuration files to .local overrides
sudo cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# 10a. Initial attempt to update /etc/fail2ban/jail.local using a heredoc (failed due to EOF formatting/backend=auto)
sudo tee /etc/fail2ban/jail.local > /dev/null << 'EOF'
[DEFAULT]
ignoreip =
ignoreself = false
bantime = 2m
findtime = 1m
maxretry = 3

[sshd]
enabled = true
backend = auto
logpath = /var/log/auth.log
EOF

sudo systemctl restart fail2ban


# 11. Test the fail2ban configuration syntax to confirm there are no errors
sudo fail2ban-client -t

# 12. Enable and restart the fail2ban service
sudo systemctl enable --now fail2ban
sudo systemctl restart fail2ban

# 13. Create a wordlist of wrong passwords to trigger the fail2ban ban threshold
printf "wrong1\nwrong2\nwrong3\nwrong4\nwrong5\n" > /tmp/wrong_pass.txt

# 14. Run Hydra in a loop against 127.0.0.1 so OpenSSH logs multiple separate "Failed password" lines
for i in 1 2 3; do hydra -l testuser -P /tmp/wrong_pass.txt ssh://127.0.0.1 -t 1 -V; done

# 15. Check the sshd jail status to verify that 127.0.0.1 was detected and banned
sudo fail2ban-client status sshd

# 16. Unban 127.0.0.1 once the ban is confirmed
sudo fail2ban-client set sshd unbanip 127.0.0.1

# 17. Clean up the temporary test user and wordlists
sudo deluser --remove-home testuser
rm -f /tmp/test-passwords.txt /tmp/wrong_pass.txt