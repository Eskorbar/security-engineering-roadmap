#!/bin/bash
# commands.sh - Week 2 Disk Forensics Workspace Lifecycle
# Focus: Automated Task Tracking & Environmental Staging

# =====================================================================
# DAY 4: ARCHITECTURAL FRAMEWORK SETUP
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
# DAY 5: ARCHITECTURAL FRAMEWORK SETUP
# =====================================================================

# WHAT I DID: Opened Autopsy and created a new case for the disk image analysis.
# → Open Autopsy → click "New Case" → Case details → Click Next → Next → Finish
# Added the disk image as a data source for analysis.
# → Click "Add Data Source" → select "Disk Image or VM File" → Browse to image file
# → click Next → Leave all ingest modules ticked → Click Finish 
# When ingest finishes — I explored these sections in Autopsy:
# Data Sources → expand the image → browse the folder structure
# Extracted Content → Web History (see every site the user visited)
# Extracted Content → Recent Documents
# Views → Deleted Files (files the user thought were gone)
