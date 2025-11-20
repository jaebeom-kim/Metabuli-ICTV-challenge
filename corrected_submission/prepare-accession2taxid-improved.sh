#!/bin/bash 

TAXONOMY_DIR=$1

# Species to taxid
awk -F '\t' '{print $3"\t"$1}' $TAXONOMY_DIR/names.dmp > $TAXONOMY_DIR/species2taxid.tsv

# Species to genbank accession
# awk -F '\t' '{if ($23 != "") print $18"_"$23}' msl.tsv | tail -n +2 > species2accession.temp.tsv
awk -F '\t' '{if(NR!=1 && $23 !="") print $18"_"$23}' msl.tsv | awk -F ' \\(' '{print $1}' > species2accession.temp.tsv

# Convert the species2accession.temp.tsv file to the desired format
#   Example input:
#   Bymovirus tritici	RNA1: MN046368; RNA2: MN046369
#   Example output:
#   Bymovirus tritici	MN046368
#   Bymovirus tritici	MN046369

awk '{
    # 1. Find the position of the first underscore to separate Species from Data
    # We use index() instead of FS="_" because the prefix might contain spaces 
    # but the separator is definitely the first underscore.
    idx = index($0, "_")
    
    # Skip lines that dont have an underscore
    if (idx == 0) next

    # Extract the Species Name (Prefix)
    # substr(string, start, length) - length is idx-1
    prefix = substr($0, 1, idx - 1)

    # Extract the rest of the line (The IDs)
    # substr(string, start) - goes to end of string
    rest = substr($0, idx + 1)

    # 2. Split the "rest" by semicolon into an array named "parts"
    n = split(rest, parts, ";")

    # 3. Loop through each part (e.g., " SegB: MK103420")
    for (i = 1; i <= n; i++) {
        item = parts[i]

        # Trim leading/trailing whitespace
        gsub(/^ +| +$/, "", item)

        # Remove labels like "SegA: " or "S: "
        # Regex matches any characters up to a colon and space
        sub(/.*: /, "", item)

        # Print in the desired format if item is not empty
        if (item != "") {
            print prefix "\t" item
        }
    }
}' species2accession.temp.tsv > species2accession.tsv


# Make accession2taxid file from species2taxid and species2accession files
awk 'BEGIN {FS=OFS="\t"} NR==FNR {taxid[$1]=$2; next} $1 in taxid {print $2, taxid[$1]}' $TAXONOMY_DIR/species2taxid.tsv species2accession.tsv > $TAXONOMY_DIR/accession2taxid.tsv

# convert the accession2taxid file to NCBIs format
awk 'BEGIN {print "accession\taccession.version\ttaxid\tgi"} {print $1"\t"$1"\t"$2"\t0"}' $TAXONOMY_DIR/accession2taxid.tsv > $TAXONOMY_DIR/ictv.accession2taxid
