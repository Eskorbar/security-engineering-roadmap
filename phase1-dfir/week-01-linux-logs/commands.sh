# =============================================
# WEEK 1 — OverTheWire Bandit: Levels 0–17
# Commands documented by Eskor
# =============================================

# --- LEVEL 0: SSH into the game server ---
ssh bandit0@bandit.labs.overthewire.org -p 2220

# --- LEVEL 1: Read a file in home directory ---
cat readme
# Lesson: basic file reading with cat

# --- LEVEL 2: File with special character "-" in name ---
cat ./-
# Lesson: ./ prefix tells cat it's a file path not a flag

# --- LEVEL 3: File with spaces in name ---
cat "spaces in this filename"
# Alternative: cat spaces\ in\ this\ filename
# Lesson: quote filenames with spaces or escape with backslash

# --- LEVEL 4: Hidden file inside a directory ---
cd inhere/
ls -la          # -a flag shows hidden files (starting with .)
cat .hidden
# Lesson: ls -la reveals hidden files attackers use to hide malware

# --- LEVEL 5: Find file by specific properties ---
find inhere/ -type f -size 1033c ! -executable | xargs cat
# Breakdown:
#   -type f         = files only (not directories)
#   -size 1033c     = exactly 1033 bytes (c = bytes)
#   ! -executable   = not executable
#   | xargs cat     = pipe filename to cat to read it
# Lesson: find files by properties during incident response

# --- LEVEL 6: Find file owned by specific user/group ---
find / -user bandit7 -group bandit6 -size 33c 2>/dev/null | xargs cat
# Breakdown:
#   find /          = search entire system from root
#   -user bandit7   = owned by user bandit7
#   -group bandit6  = belongs to group bandit6
#   -size 33c       = exactly 33 bytes
#   2>/dev/null     = hide "Permission denied" errors
#   | xargs cat     = read the found file
# Lesson: find attacker-planted files by ownership during IR

# --- LEVEL 7: Find password next to a keyword ---
grep "millionth" data.txt
# Lesson: search large files for specific strings — core log analysis skill

# --- LEVEL 8: Find unique line in a file ---
sort data.txt | uniq -u
# Breakdown:
#   sort            = alphabetically sort all lines
#   uniq -u         = show only lines that appear exactly ONCE
# Lesson: find anomalies in log files — the unique event is the suspicious one

# --- LEVEL 9: Extract readable strings from binary file ---
strings data.txt | grep '=='
# Breakdown:
#   strings         = extract all human-readable text from binary
#   grep '=='       = filter for lines with == (password marker)
# Lesson: extract readable content from malware binaries during triage

# --- LEVEL 10: Decode base64 encoded data ---
base64 -d data.txt
# Alternative:
cat data.txt | base64 --decode
# Lesson: attackers encode payloads in base64 to evade detection

# --- LEVEL 11: Decode ROT13 encoded text ---
cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'
# Breakdown:
#   tr              = translate/replace characters
#   'A-Za-z'        = input character range
#   'N-ZA-Mn-za-m'  = shift every letter by 13 positions (ROT13)
# Lesson: simple obfuscation used in malware and CTFs

# --- LEVEL 12: Decompress multiple nested archives ---
# Make working directory (can't modify /tmp directly)
mkdir /tmp/workdir && cp data.txt /tmp/workdir/ && cd /tmp/workdir
# Identify file type regardless of extension
file data.txt
# Decompress based on type:
xxd data.txt | head          # view hex dump
mv data.txt data.gz
gunzip data.gz               # extract .gz
bunzip2 filename.bz2         # extract .bz2
tar -xf filename.tar         # extract .tar archive
# Repeat file → rename → decompress until you get ASCII text
# Lesson: attackers layer compression to hide malware — learn to unwrap it

# --- LEVEL 13: SSH using private key instead of password ---
# Transfer key to local machine first
scp -P 2220 bandit13@bandit.labs.overthewire.org:~/sshkey.private C:\Users\Eskor\bandit14.key
# Fix permissions (SSH refuses keys that are too open)
chmod 400 sshkey.private
# SSH using the key
ssh -i C:\Users\Eskor\bandit14.key bandit14@bandit.labs.overthewire.org -p 2220
# Read the password file once inside
cat /etc/bandit_pass/bandit14
# Lesson: SSH key auth is how ALL cloud servers (AWS EC2) authenticate

# --- LEVEL 14: Connect to a port using netcat ---
nc localhost 30000
# Then paste the level 14 password when prompted
# Lesson: nc (netcat) is the Swiss army knife of networking —
#         used to test open ports, send data, and debug services

# --- LEVEL 15: SSL/TLS encrypted connection ---
openssl s_client -connect localhost:30001 -ign_eof
# Breakdown:
#   openssl s_client        = create SSL/TLS connection (like HTTPS by hand)
#   -connect localhost:30001 = target host and port
#   -ign_eof                = stay connected after pasting password
# Then paste the level 15 password when connected
# Lesson: understand how encrypted connections work —
#         used in pen testing and verifying SSL configs

# --- LEVEL 16: Find open ports then connect with SSL ---
nmap -sV localhost -p 31000-32000    # scan port range for open SSL ports
openssl s_client -connect localhost:[correct_port] -ign_eof
# Lesson: port scanning to find services — core recon and IR technique

# =============================================
# LOG ANALYSIS COMMANDS (auth.log)
# =============================================

# Extract top attacker IPs (rhost= format)
grep 'authentication failure' auth.log | grep -oE 'rhost=[^ ]+' | cut -d= -f2 | sort | uniq -c | sort -rn | head -10

# Extract targeted usernames
grep 'authentication failure' auth.log | grep -oE 'user=[^ ]+' | cut -d= -f2 | sort | uniq -c | sort -rn | head -10

# Count failed attempts per day
grep 'authentication failure' auth.log | awk '{print $1, $2}' | sort | uniq -c | sort -rn

# Extract IP regardless of log format
grep -i 'fail' auth.log | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort | uniq -c | sort -rn | head -10
