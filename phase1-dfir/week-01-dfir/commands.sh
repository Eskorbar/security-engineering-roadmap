#!/bin/bash
# commands.sh - Complete Week 1 Automated Progress & Security Auditing Tracker
# Focus: Linux Log Forensics, Privilege Escalation, and Attack Surface Discovery
# =============================================================
# WEEK 1 - Linux CLI, SSH, Netcat, SSL, Grep, Port Scanning
# Security Engineering Roadmap - Eskor
# All commands documented with full explanations
# NOTE: Bandit passwords stored in Google Drive ONLY
#       Never push passwords to GitHub
# =============================================================


# =============================================================
# BANDIT LEVEL SOLUTIONS
# Commands used at each level - documented for reference
# Passwords stored in Google Drive ONLY - never pushed to GitHub
# =============================================================

# --- LEVEL 0: SSH into the game server ---
ssh bandit0@bandit.labs.overthewire.org -p 2220
# Lesson: basic SSH connection - this is how you access every cloud server

# --- LEVEL 1: Read a file in home directory ---
cat readme
# cat = concatenate and print - reads a file and outputs contents to terminal
# Lesson: cat is the fastest way to read any file on a Linux system

# --- LEVEL 2: File with special character "-" in name ---
cat ./-
# ./ prefix tells Linux this is a file path, not a command flag
# Without ./: cat - means "read from keyboard input" (not a file)
# Lesson: attackers name files with special characters to confuse admins

# --- LEVEL 3: File with spaces in the name ---
cat "spaces in this filename"
# Alternative: cat spaces\ in\ this\ filename (backslash escapes each space)
# Lesson: always quote or escape filenames with unusual characters

# --- LEVEL 4: Hidden file inside a directory ---
cd inhere/
ls -la
# -l = long format (shows permissions, owner, size)
# -a = all files including hidden (files starting with . are hidden in Linux)
# Then: cat .hidden
# Lesson: always use ls -la in investigations - never just ls
#         Hidden files starting with . are a common attacker technique

# --- LEVEL 5: Find file by specific properties ---
find inhere/ -type f -size 1033c ! -executable | xargs cat
# find        = search for files/directories
# inhere/     = search inside this directory
# -type f     = files only (not directories)
# -size 1033c = exactly 1033 bytes (c = bytes, k = kilobytes, M = megabytes)
# ! -executable = NOT executable
# | xargs cat = pipe the found filename to cat (reads it immediately)
# Lesson: find files by properties during incident response -
#         attackers drop files in unexpected locations

# --- LEVEL 6: Find file owned by specific user and group ---
find / -user bandit7 -group bandit6 -size 33c 2>/dev/null | xargs cat
# /           = search entire system from root
# -user       = owned by this user
# -group      = belonging to this group
# 2>/dev/null = redirect all errors (Permission denied) to /dev/null (discard them)
#               Without this: hundreds of error lines flood your output
# Lesson: hunt files by ownership across an entire server
#         Used to find attacker-created files during incident response

# --- LEVEL 7: Find text next to a keyword ---
grep "millionth" data.txt
# Searches data.txt for the line containing "millionth"
# Lesson: grep searches millions of lines instantly - core log analysis skill

# --- LEVEL 8: Find the unique line ---
sort data.txt | uniq -u
# sort    = alphabetically sort all lines (groups duplicate lines together)
# uniq -u = show only lines that appear exactly ONCE (unique)
# Lesson: finding anomalies - the unique event is usually the suspicious one

# --- LEVEL 9: Extract readable strings from binary file ---
strings data.txt | grep '=='
# strings = extract all human-readable text sequences from a binary file
# | grep '==' = filter for lines containing == (the password marker)
# Lesson: first tool malware analysts run on a suspicious binary
#         Extracts hardcoded URLs, IPs, file paths, registry keys without executing it

# --- LEVEL 10: Decode base64 ---
base64 -d data.txt
# base64 -d = decode base64 encoded data back to plain text
# Alternative: cat data.txt | base64 --decode
# Lesson: attackers encode payloads in base64 to evade detection
#         PowerShell malware almost always uses base64 encoding

# --- LEVEL 11: Decode ROT13 ---
cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'
# tr = translate/replace characters
# 'A-Za-z'       = input: all letters A through Z (upper and lower)
# 'N-ZA-Mn-za-m' = output: shift each letter 13 positions (ROT13)
# Example: A becomes N, B becomes O, N becomes A (wraps around)
# Lesson: simple obfuscation - appears in CTFs and occasionally real malware

# --- LEVEL 12: Decompress multiple nested archives ---
# First: make a working directory (can't write to /tmp directly)
mkdir /tmp/workdir && cp data.txt /tmp/workdir/ && cd /tmp/workdir

# Identify file type regardless of extension:
file data.txt
# file command reads the file header to identify type
# More reliable than file extension (extensions can be faked)

# Then decompress based on what file command tells you:
mv data.txt data.gz && gunzip data.gz       # for .gz files
bunzip2 filename.bz2                         # for .bz2 files
tar -xf filename.tar                         # for .tar archives
# Repeat: file -> rename -> decompress until you reach ASCII text
# Lesson: attackers layer compression to slow down analysis and evade detection

# --- LEVEL 13: SSH using private key ---
# Copy key from server to local machine:
scp -P 2220 bandit13@bandit.labs.overthewire.org:~/sshkey.private \path\to\bandit14.key
# Fix permissions:
chmod 400 /path/to/bandit14.key
# Connect using the key:
ssh -i /path/to/bandit14.key bandit14@bandit.labs.overthewire.org -p 2220
# Read the password file once inside:
cat /etc/bandit_pass/bandit14
# Lesson: SSH key authentication is how all cloud servers work
#         AWS EC2, GitHub, and all production servers use this exact method

# --- LEVEL 14: Connect to a port with netcat ---
nc localhost 30000
# Paste the level 14 password when prompted
# Lesson: netcat is the Swiss army knife of networking
#         Used to test ports, send data, debug services, and create listeners

# --- LEVEL 15: SSL encrypted connection ---
openssl s_client -connect localhost:30001 -ign_eof
# Connect and paste the level 15 password when you see "read R BLOCK"
# Lesson: SSL/TLS is the encryption layer under HTTPS
#         openssl s_client lets you interact with encrypted services by hand

# --- LEVEL 16: Find open SSL ports then connect ---
# First scan to find which ports are open:
nmap -sV localhost -p 31000-32000
# Or using netcat:
nc -zv localhost 31000-32000
# Then connect to the port running SSL:
openssl s_client -connect localhost:31790 -ign_eof
# Paste the level 16 password - receive an RSA private key in response
# Lesson: port scanning finds what services are running and where
#         Used in penetration testing and incident response

# --- LEVEL 17: Compare two files to find the changed line ---
diff passwords.old passwords.new
# diff = show differences between two files
# Lines with < = only in the first file (old)
# Lines with > = only in the second file (new)
# The line only in passwords.new is the password
# Lesson: diff is used in security to compare config files before and after changes
#         Attackers who modify configs leave traces that diff reveals

# --- LEVEL 18: The Shell escape ---
ssh bandit18@bandit.labs.overthewire.org -p 2220 "cat readme"
# I tried to ssh into bandit18 servers but I was immediately logged out with a "bye bye" message
# The solution was to run a command on the server without opening an interactive shell:
# The server forces the command cat readme to run instantly, prints Level 19 password to tthe screen, and then closes the connection.
# Lesson: attackers can lock you out of a server by modifying your shell
#         You can still run commands remotely without an interactive shell
# Interactive shells and automated execution profiles (.bashrc) are two different phases of a login sequence.
#           If an administrator places a guard at the front door to kick you out,
#           passing a direct command via SSH is like shouting your request through an open window instead of walking through the door.
#           The system processes the request first, outputs the data, and then gracefully closes the session

# --- LEVEL 19: The Shell escape ---
./bandit20-do ls /etc/bandit_pass
./bandit20-do cat /etc/bandit_pass/bandit20
# The bandit20-do program is a setuid binary that runs as the bandit20 user.
# It only allows the ls and cat commands, but it is vulnerable to shell escape.
# By running ./bandit20-do ls /etc/bandit_pass, I can see the password file for bandit20.
# Then I can run ./bandit20-do cat /etc/bandit_pass/bandit20 to read the password for bandit20.
# Lesson: attackers can exploit poorly written programs to gain access to sensitive files
#         Always check for setuid binaries and test them for vulnerabilities

# --- LEVEL 20: Netcat local socket binding & multi-terminal verification handshake ---
# WHAT I DID: Created a local socket listening post to link data across processes.
# Window 1 (Listener Setup):
nc -l -p 54321
# Window 2 (SUID Connection Initiation):
./suconnect 54321
# Window 1 (Listener Output):
# The suconnect program connects to the listener on port 54321 and sends the password for bandit21
# Lesson: netcat can be used to create local sockets for inter-process communication
#         This technique is useful for testing and debugging services that require multiple connections
#
#
# --- LEVEL 21: Scheduled Background Tasks (Cron) ---
# WHAT I DID: Audited system cron schedules and traced automated script outputs.
cd /etc/cron.d
cat cronjob_bandit22
# The configuration file pointed to an active script running on a 1-minute interval.
cat /usr/bin/cronjob_bandit22.sh
# Reading the script code revealed the static text file destination where the password leaks.
cat /tmp/t7O6RIUz9U37N7Y6BBgYST68g7vEsR9O
# Lesson: System schedulers are highly predictable if configurations are left globally readable.

# --- LEVEL 22: Decoding Runtime Script Logic ---
# WHAT I DID: Simulated hashing variables natively to predict a dynamic destination.
cat /usr/bin/cronjob_bandit23.sh
# The code maps a dynamic file generation path using an MD5 check on user parameters.
# Replicated the hash loop directly inside the interactive terminal to calculate the filename:
echo "I am user bandit23" | md5sum | cut -d ' ' -f 1
# Used the generated hash output to pinpoint and open the hidden flag file:
cat /tmp/8169b67bd894dd1e9301dd9745648579
# Lesson: Security through obscurity fails when the logic to build the secret is fully exposed.

# --- LEVEL 23: Script Injection & Privilege Delegation ---
# WHAT I DID: Created an exfiltration script and staged it for automated root-level execution.
# Created a script payload inside a globally writable sandbox folder:
cd /tmp
nano myscript.sh
# [Script contents]:
# #!/bin/bash
# cat /etc/bandit_pass/bandit24 > /tmp/my_secret_flag.txt
#
# Opened global read/write/execute flags so the scheduler daemon could process it:
chmod 777 myscript.sh
# Moved the payload to the specific spool directory watched by the automated root process:
cp myscript.sh /var/spool/bandit24/foo/
# Allowed 60 seconds for the system alarm clock to cycle, execute the script, and drop the key:
cat /tmp/my_secret_flag.txt
# Lesson: Writable spool pathways coupled with high-privilege runners invite arbitrary code execution.




# =============================================================
# SECTION 1: SSH - SECURE SHELL
# How to connect to remote Linux servers securely
# =============================================================

# --- BASIC SSH CONNECTION ---
# Structure: ssh username@hostname -p port
ssh bandit0@bandit.labs.overthewire.org -p 2220
# username    = bandit0
# hostname    = bandit.labs.overthewire.org
# -p 2220     = connect on port 2220 (default SSH port is 22)
# When prompted: enter the password for that level

# --- SSH WITH VERBOSE OUTPUT (useful for debugging) ---
ssh -v bandit0@bandit.labs.overthewire.org -p 2220
# -v = verbose - shows exactly what SSH is doing step by step
# Use this when a connection fails and you want to know why

# --- RUN A COMMAND ON A REMOTE SERVER WITHOUT INTERACTIVE SHELL ---
ssh bandit18@bandit.labs.overthewire.org -p 2220 "cat readme"
# Runs "cat readme" on the server and immediately returns the output
# Used in Bandit Level 18 where .bashrc logs you out on login
# In real life: run a quick check on a server without fully logging in

# --- SSH USING A PRIVATE KEY INSTEAD OF PASSWORD ---
# This is how ALL cloud servers (AWS EC2, DigitalOcean) authenticate
# Structure: ssh -i keyfile username@hostname -p port
ssh -i /path/to/bandit14.key bandit14@bandit.labs.overthewire.org -p 2220
# -i /path/to/bandit14.key = use this private key file as your identity
# No password needed - the key proves who you are

# --- HOW SSH KEY AUTHENTICATION WORKS ---
# You have TWO files (a key pair):
#   Private key = stays on YOUR machine, never shared (bandit14.key)
#   Public key  = lives on the SERVER in ~/.ssh/authorized_keys
#
# When you connect:
#   Your machine says "I have the private key matching this public key"
#   Server checks if that public key is in its authorized_keys file
#   If yes: access granted - no password needed
#
# Why keys are more secure than passwords:
#   Passwords can be guessed, leaked, or brute-forced
#   Keys are mathematically unforgeable without the private file

# --- FIX SSH KEY PERMISSIONS ---
chmod 400 sshkey.private
# SSH REFUSES to use a private key if other users can read it
# chmod 400 = read permission for owner only, nothing for anyone else
# Permission breakdown:
#   4 = read for owner
#   0 = no permission for group
#   0 = no permission for others
# Always run this before using a private key

# --- SCP: COPY FILES SECURELY BETWEEN MACHINES ---
# Structure: scp -P port source destination
scp -P 2220 bandit13@bandit.labs.overthewire.org:~/sshkey.private \path\to\bandit14.key
# -P 2220     = port (NOTE: capital P for scp, lowercase p for ssh)
# source      = bandit13@server:~/sshkey.private (file on remote server)
#               ~ means home directory on the remote machine
# destination = \path\to\bandit14.key (where to save it locally)
# In real life: download a file from a server, upload config files, transfer logs


# =============================================================
# SECTION 2: GREP - SEARCHING FILES AND STREAMS
# The most used command in log analysis and forensics
# =============================================================

# --- BASIC GREP ---
grep 'Failed password' auth.log
# Searches auth.log for every line containing "Failed password"
# Returns the full line for each match

# --- CASE INSENSITIVE ---
grep -i 'failed password' auth.log
# -i = ignore case - matches Failed, FAILED, failed, FaIlEd

# --- INVERT MATCH (show lines that do NOT match) ---
grep -v 'Failed password' auth.log
# -v = invert - returns every line that does NOT contain "Failed password"
# Useful for filtering out noise you don't want to see

# --- SHOW LINE NUMBERS ---
grep -n 'Failed password' auth.log
# -n = prefix each result with its line number
# Useful when you need to go back to a specific line later

# --- COUNT MATCHING LINES ---
grep -c 'Failed password' auth.log
# -c = count - returns only the number of matching lines, not the lines themselves
# Fast way to see how many times something occurred

# --- SEARCH RECURSIVELY THROUGH A DIRECTORY ---
grep -r 'error' /var/log/
# -r = recursive - searches every file in /var/log/ and all subdirectories
# In real life: search all log files at once for an error

# --- TREAT BINARY FILE AS TEXT ---
grep -a '==' data.txt
# -a = treat binary file as ASCII text
# Used in Bandit Level 9 where data.txt was a binary file

# --- ONLY PRINT THE MATCHED PART (not the whole line) ---
grep -o 'rhost=[^ ]*' auth.log
# -o = only output the matched text, not the whole line
# Without -o: Jun 14 15:16:01 sshd: authentication failure; rhost=1.2.3.4 user=root
# With -o:    rhost=1.2.3.4
# Makes piping to cut/awk much cleaner

# --- EXTENDED REGEX ---
grep -E 'rhost=[^ ]+' auth.log
# -E = extended regex - enables more powerful pattern matching
# [^ ]+ means "one or more characters that are NOT a space"

# --- COMBINED: -oE IS YOUR MOST POWERFUL GREP FOR LOG ANALYSIS ---
grep -oE 'rhost=[^ ]+' auth.log
# -o = only the matched part
# -E = extended regex
# Together: extract exactly the pattern you want from messy log lines

# --- GREP PATTERNS (REGEX) YOU NEED TO KNOW ---

# Any IP address in a file:
grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' auth.log
# [0-9]+  = one or more digits
# \.      = literal dot (. alone means "any character")
# Repeated 4 times with dots = IP address pattern

# Lines starting with a specific word:
grep '^Failed' auth.log
# ^ = start of line - only matches "Failed" when it is the FIRST thing on the line

# Lines ending with a specific word:
grep 'session$' auth.log
# $ = end of line - only matches "session" when it is the LAST thing on the line

# Match any single character:
grep 'bandit.' auth.log
# . = any single character - matches bandit0, bandit1, banditX etc.

# Match multiple possible values:
grep -E 'root|admin|ubuntu' auth.log
# | = OR - matches lines containing root OR admin OR ubuntu

# --- FULL LOG ANALYSIS WORKFLOW (used in Week 1 - 14th/09/2026) ---

# Find top 10 attacking IPs:
grep 'authentication failure' auth.log | grep -oE 'rhost=[^ ]+' | cut -d= -f2 | sort | uniq -c | sort -rn | head -10
# Step 1: grep 'authentication failure' auth.log  = get all failure lines
# Step 2: grep -oE 'rhost=[^ ]+'                 = extract the rhost=IP part
# Step 3: cut -d= -f2                             = remove "rhost=" keep only the IP
#         -d= means delimiter is =
#         -f2 means take field 2 (after the =)
# Step 4: sort                                    = sort IPs alphabetically (groups same IPs)
# Step 5: uniq -c                                 = count consecutive duplicates
#         -c = prefix each line with count
# Step 6: sort -rn                                = sort by number, highest first
#         -r = reverse (biggest first)
#         -n = numeric sort (not alphabetical)
# Step 7: head -10                                = show only the top 10

# Find targeted usernames:
grep 'authentication failure' auth.log | grep -oE 'user=[^ ]+' | cut -d= -f2 | sort | uniq -c | sort -rn | head -10

# Count attacks per day:
grep 'authentication failure' auth.log | awk '{print $1, $2}' | sort | uniq -c | sort -rn
# awk '{print $1, $2}' = print columns 1 and 2 (month and day from log timestamp)

# Check if any attacker SUCCEEDED (most important check):
grep 'Accepted password' auth.log | grep -oE 'from [^ ]+' | cut -d' ' -f2
# Cross-reference these IPs against your attacker list
# Any overlap = confirmed breach


# =============================================================
# SECTION 3: NETCAT (nc) - THE SWISS ARMY KNIFE OF NETWORKING
# =============================================================

# --- CONNECT TO A PORT (Bandit Level 14) ---
nc localhost 30000
# Opens a raw TCP connection to localhost on port 30000
# Whatever you type is sent to the service
# Whatever the service sends back appears on your screen
# Used to: test ports, send data manually, interact with services

# --- NETCAT AS A LISTENER (Bandit Level 20) ---
nc -l -p 1234
# -l = listen mode (wait for incoming connections)
# -p 1234 = listen on port 1234
# Used in Level 20: Terminal 1 listens, Terminal 2 connects

# --- SCAN IF A PORT IS OPEN ---
nc -zv localhost 30000
# -z = zero I/O mode (scan only, don't send data)
# -v = verbose (show results clearly)
# Output: Connection to localhost 30000 port [tcp/*] succeeded = OPEN
# Output: localhost: inverse host lookup failed = CLOSED or FILTERED

# --- SCAN A RANGE OF PORTS ---
nc -zv localhost 30000-32000
# Scans every port from 30000 to 32000
# Used in Bandit Level 16 to find which port was running SSL


# =============================================================
# SECTION 4: SSL/TLS - ENCRYPTED CONNECTIONS
# =============================================================

# --- WHAT SSL/TLS IS ---
# Without SSL (plain netcat):
#   Your machine ----[username: admin, password: 1234]----> Server
#   Anyone watching the network reads everything
#
# With SSL/TLS:
#   Your machine ----[₯#@£∂ encrypted gibberish]----> Server
#   Anyone watching sees: nothing useful
#
# SSL/TLS is the encryption layer under HTTPS, SMTPS, and any secure service

# --- CONNECT TO AN SSL/TLS SERVICE (Bandit Level 15) ---
openssl s_client -connect localhost:30001 -ign_eof
# openssl        = the command line tool for encryption and SSL
# s_client       = subcommand - act as an SSL client (connect to a server)
# -connect       = specify host:port to connect to
# localhost:30001 = connect to port 30001 on the local machine
# -ign_eof       = ignore End Of File
#                  Without this: openssl closes when your input ends (before server responds)
#                  With this: stays connected so you can read the server's reply

# --- WHAT YOU SEE WHEN SSL CONNECTS ---
# CONNECTED(00000003)
# depth=0 CN = localhost
# [certificate information]
# ---
# read R BLOCK       <-- this means: connected and waiting for your input
# [paste your password here, press Enter]

# --- USEFUL OPENSSL CHECKS FOR REAL WORK ---

# Check a website's SSL certificate:
openssl s_client -connect google.com:443
# Useful for: verifying cert is valid, checking expiry date, seeing what SSL version is used

# Check SSL certificate expiry date:
echo | openssl s_client -connect google.com:443 2>/dev/null | openssl x509 -noout -dates
# Shows: notBefore (when cert was issued) and notAfter (when cert expires)
# In real life: audit certificates before they expire and break your service


# =============================================================
# SECTION 5: PORT SCANNING - FINDING WHAT'S RUNNING WHERE
# =============================================================

# --- SCAN WITH NETCAT (already covered above) ---
nc -zv localhost 30000-32000
# Fast, lightweight, available everywhere
# Limitation: can't detect service type or version

# --- SCAN WITH NMAP (more powerful) ---
# Note: nmap may need installing - sudo apt install nmap

# Scan common ports:
nmap localhost
# Checks the 1000 most common ports by default

# Scan a specific port range:
nmap -p 30000-32000 localhost

# Detect service version on each open port:
nmap -sV localhost
# -sV = service version detection
# Output: 30001/tcp open ssl/http
#         31790/tcp open ssl/http   <- this was the answer in Bandit Level 16

# Scan ALL 65535 ports:
nmap -p- localhost
# Slower but thorough - used when you don't know what port range to check

# --- WHAT SCAN RESULTS MEAN ---
# open     = something is actively listening on this port
# closed   = port is reachable but nothing is listening
# filtered = firewall is blocking - you can't tell if it's open or closed

# --- IN REAL LIFE ---
# Incident response: scan a compromised server to find backdoors on unusual ports
# Penetration testing: find the attack surface on a target
# Security audits: verify only the correct ports are open on your production servers