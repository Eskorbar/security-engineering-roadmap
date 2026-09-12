# =============================================
# WEEK 1 — Linux CLI & Log Analysis
# =============================================

# --- BANDIT LEVELS ---

# Level 0: SSH into server
ssh bandit0@bandit.labs.overthewire.org -p 2220

# Level 5: find file by size and properties
find inhere/ -type f -size 1033c ! -executable | xargs cat

# Level 9: extract readable strings from binary
strings data.txt | grep '=='

# Level 10: decode base64
base64 -d data.txt

# Level 11: decode ROT13
cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'

# Level 13: SSH using private key
ssh -i sshkey.private bandit14@bandit.labs.overthewire.org -p 2220

# --- LOG ANALYSIS ---

# Extract top attacker IPs from auth.log
grep 'authentication failure' auth.log | grep -oE 'rhost=[^ ]+' | cut -d= -f2 | sort | uniq -c | sort -rn | head -10

# Extract targeted usernames
grep 'authentication failure' auth.log | grep -oE 'user=[^ ]+' | cut -d= -f2 | sort | uniq -c | sort -rn | head -10

# Count failed attempts per day
grep 'authentication failure' auth.log | awk '{print $1, $2}' | sort | uniq -c | sort -rn