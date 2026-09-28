#!/bin/bash
# commands.sh - Week 2 Disk Forensics Workspace Lifecycle
# Focus: Automated Task Tracking & Environmental Staging

# =====================================================================
# DAY 5: ARCHITECTURAL FRAMEWORK SETUP
# =====================================================================

# Initialize Week 2 file structure to segment incoming forensic artifact data
# WHAT I DID:
# Installed Autopsy (GUI) and Sleuth Kit (CLI) on my machine.
# These tools will be used to analyze the disk image.
# Downloaded the disk image file (2020JimmyWilson.E01) and placed it in the appropriate directory for analysis.
# Staged empty template paths using Git Bash to track documentation and logs natively.
mkdir -p phase1-dfir/week-02-disk-forensics
touch phase1-dfir/week-02-disk-forensics/findings.txt
touch phase1-dfir/week-02-disk-forensics/commands.sh
touch phase1-dfir/week-02-disk-forensics/evidence-log.txt


# =====================================================================
# DAY 6: ARCHITECTURAL FRAMEWORK SETUP
# =====================================================================
# WHAT I DID:
# Opened Autopsy, initialized a new analytical case database, 
# and ingested the raw practice disk image container to extract live and deleted filesystem fragments.
    # Step 1: Open Autopsy -> click "New Case" -> Input case details -> Click Next -> Next -> Finish
    # Step 2: Click "Add Data Source" -> select "Disk Image or VM File" -> Browse to image file -> click Next
    # Step 3: Enable all ingest modules (automated artifact analyzers) -> Click Finish
# Post-Ingestion Navigation Arrays:
    # - Data Sources -> Expand target image file node -> Browse directory structures manually
    # - Extracted Content -> Web History -> Audit historical browser sessions and timelines
    # - Extracted Content -> Recent Documents -> Isolate user access events preceding the snapshot
    # - Views -> Deleted Files -> Identify target fragments marked with filesystem deletion flags
# Platform: Autopsy GUI Analysis Engine


# =====================================================================
# DAY 7: NMAP LOCALHOST PORT AUDIT
# =====================================================================
# WHAT I DID: 
# Scanned my machine for open ports and their services
# Command Executed:
    # nmap -sS -p- localhost
    # nmap localhost
    # nmap -sV localhost    (detect service versions on open ports)
    # nmap -p 80,443,22,3389 localhost   (check specific ports)


# =====================================================================
# DAY 8: Wireshark PCAP + Brute Force Awareness + Nmap
# =====================================================================
# Advanced network enumeration scans against the local loopback adapter (localhost) 
    # using Nmap via the Zenmap GUI. Focused on 
    # service version detection using 'nmap -sV -O localhost', 
    # port restrictions via 'nmap -p 1-1000 localhost'
    # and comprehensive aggressive script evaluation using 'nmap -A localhost'.
#------------------------------------------------------------------------------
#----- Day 10 Wireshark & PCAP Analysis Helpers ----
#------------------------------------------------------------------------------
# Filter references used in Wireshark:
    # tcp.flags.syn == 1 && tcp.flags.ack == 0
    # http.request.method == "POST"
    # dns && dns.qry.name contains ".ru"

