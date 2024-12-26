#!/bin/sh 

OUTDIR=$1

# Download the assembly summary file
wget https://ftp.ncbi.nlm.nih.gov/genomes/genbank/viral/assembly_summary.txt

# Extract the download links from the assembly summary file
awk -F '\t' '{print $20}' assembly_summary.txt | tail -n +3 | awk -F '/' '{print $0"/"$NF"_genomic.fna.gz"}' > genbank_ftp_links.txt

# Download the genomes
aria2c -x 16 -j 16 -s 16 -i genbank_ftp_links.txt -d $OUTDIR








