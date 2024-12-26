#!/bin/bash 

TAXONOMY_DIR=$1
# Reference: https://github.com/shenwei356/ictv-taxdump/README.md

# Download the VMR MSL
wget https://ictv.global/sites/default/files/VMR/VMR_MSL39.v4_20241106.xlsx

# Extract MSL as a TSV file
csvtk xlsx2csv VMR_MSL39.v4_20241106.xlsx -n "VMR MSL39" | csvtk csv2tab > msl.tsv

sed -i 's/\xc2\xa0/ /g' msl.tsv

# remove a newline character and a space introduced by accident
csvtk replace -t -F -f "*" -p "^\s+|\s+$" msl.tsv \
    | csvtk replace -t -F -f "*" -p "\n " -r "" \
    > msl.clean.tsv

# choose columns, rename, and remove duplicates
csvtk cut -t msl.clean.tsv -f "Realm,Subrealm,Kingdom,Subkingdom,Phylum,Subphylum,Class,Subclass,Order,Suborder,Family,Subfamily,Genus,Subgenus,Species" \
    | csvtk rename -t -f 1- -n "realm,subrealm,kingdom,subkingdom,phylum,subphylum,class,subclass,order,suborder,family,subfamily,genus,subgenus,species" \
    | csvtk uniq   -t -f 1- \
    > msl.taxonomy.tsv

taxonkit create-taxdump msl.taxonomy.tsv --out-dir $TAXONOMY_DIR



