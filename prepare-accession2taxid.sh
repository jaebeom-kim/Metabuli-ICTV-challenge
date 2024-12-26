#!/bin/bash 

TAXONOMY_DIR=$1

# Species to taxid
awk -F '\t' '{print $3"\t"$1}' $TAXONOMY_DIR/names.dmp > $TAXONOMY_DIR/species2taxid.tsv

# Species to genbank accession
awk -F '\t' '{if ($23 != "") print $18"\t"$23}' msl.clean.tsv | tail -n +2 > $TAXONOMY_DIR/species2accession.temp.tsv


# Convert the species2accession file to the desired format
#   Example input:
#   Bymovirus tritici	RNA1: MN046368; RNA2: MN046369
#   Example output:
#   Bymovirus tritici	MN046368
#   Bymovirus tritici	MN046369

# Input file
input_file="$TAXONOMY_DIR/species2accession.temp.tsv"
output_file="$TAXONOMY_DIR/species2accession.tsv"

# Clear the output file if it exists
> "$output_file"

# Process the input file line by line
while IFS= read -r line; do
    # Extract the species name and the rest of the line
    species_name=$(echo "$line" | awk -F'\t' '{print $1}')
    rest=$(echo "$line" | awk -F'\t' '{print $2}')
    
    # Check if the rest contains multiple key-value pairs
    if [[ "$rest" == *";"* ]]; then
        # Split the key-value pairs by ';' and iterate over them
        echo "$rest" | tr ';' '\n' | while IFS= read -r pair; do
            # Extract the value part after ':'
            value=$(echo "$pair" | awk -F': ' '{print $2}')
            # Write the species name and value to the output file
            echo -e "$species_name\t$value" >> "$output_file"
        done
    else
        # For lines with a single value, write them as is
        echo -e "$species_name\t$rest" >> "$output_file"
    fi
done < "$input_file"

# Make accession2taxid file from species2taxid and species2accession files
awk 'BEGIN {FS=OFS="\t"} NR==FNR {taxid[$1]=$2; next} $1 in taxid {print $2, taxid[$1]}' $TAXONOMY_DIR/species2taxid.tsv $output_file > $TAXONOMY_DIR/accession2taxid.tsv

# convert the accession2taxid file to NCBIs format
awk 'BEGIN {print "accession\taccession.version\ttaxid\tgi"} {print $1"\t"$1"\t"$2"\t0"}' $TAXONOMY_DIR/accession2taxid.tsv > $TAXONOMY_DIR/ictv.accession2taxid
