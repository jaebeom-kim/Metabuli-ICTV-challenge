# Metabuli-ICTV-challenge

## Contents

1. [Introduction](#introduction)
2. [Database preparation](#database-preparation)
3. [Classification](#classification)
4. [Reformatting](#reformatting)

## Introduction
[Metabuli](https://github.com/steineggerlab/Metabuli) combines advatanges of amino acid and nucleotide sequence search. 
Please refer to the [Metabuli repository](https://github.com/steineggerlab/Metabuli) to install the software.
Pre-built binaries and bioconda packages are available.

We also provide [Metabuli App](http://github.com/steineggerlab/Metabuli-App) for user-friendly graphical interface to run the taxonomic classification and result visualization.

For more details, please see
[Nature Methods](https://www.nature.com/articles/s41592-024-02273-y), 
[PDF](https://www.nature.com/articles/s41592-024-02273-y.epdf?sharing_token=je_2D5Su0-xVOSjuKSAXF9RgN0jAjWel9jnR3ZoTv0M7gE7NDF_xi_3sW8QdRiwfSJNwqaXItSoeCvr7cvcoQxKLt0oROgWc6urmki9tP80cXEuHPN0D7b4y9y3i8Yv7sZw8MxxhAj7W6p9eZE2zaK3eozdOkXvwADVfso9cXIM%3D), 
[bioRxiv](https://www.biorxiv.org/content/10.1101/2023.05.31.543018v2), or [ISMB 2023 talk](https://www.youtube.com/watch?v=vz2fuRcVwyk).

Please cite: [Kim J, Steinegger M. Metabuli: sensitive and specific metagenomic classification via joint analysis of amino acid and DNA. Nature Methods (2024).](https://doi.org/10.1038/s41592-024-02273-y)

## Database preparation
You can download the database used for this challenge [here](https://hulk.mmseqs.com/jaebeom/vmr39.4/).
It was built using genbank genomes and MSL39.4 taxonomy.


Please follow the instructions below if you want to build your own database.

### 1. Download genbank genomes
```bash
Dependencies: wget, awk, aria2c

./download_genbank_genomes.sh GENOMES_DIR

```

### 2. Prepare ICTV taxonomy dump files
```bash
Dependencies: wget, awk, csvtk, taxonkit

./prepare-ictv-taxdump.sh TAXONOMY_DIR
```

### 3. Prepare accession2taxid mapping
```bash
./prepare-accession2taxid.sh TAXONOMY_DIR
```

### 4. Build a database
```bash
Dependencies: metabuli

find GENOMES_DIR -name "*.fna.gz" > genomes.txt

metabuli add-to-library genomes.txt TAXONOMY_DIR/ictv.accession2taxid DB_DIR --taxonomy-path TAXONOMY_DIR

find DB_DIR/library -name "*.fna" > library-files.txt

metabuli build DB_DIR library-files.txt TAXONOMY_DIR/ictv.accession2taxid --taxonomy-path TAXONOMY_DIR

```

## Classification

### 1. Merge the query sequences
```bash
You need to merge FASTA files in "ICTV-TaxonomyChallenge/dataset/dataset_challenge" directory into one file.
```

### 2. Run Metabuli
```bash
# Default mode
metabuli classify --seq-mode 1 MERGED_QUERY_FILE DB_DIR RESULT_DIR JOB_ID1 --lineage 1

# Precise mode optimized for Ilumina short reads
metabuli classify --seq-mode 1 MERGED_QUERY_FILE DB_DIR RESULT_DIR JOB_ID2 --min-score 0.15 --min-sp-score 0.5 --lineage 1

# Precise mode optimized for HiFi long reads
metabuli classify --seq-mode 1 MERGED_QUERY_FILE DB_DIR RESULT_DIR JOB_ID3 --min-score 0.07 --min-sp-score 0.3 --lineage 1

It will generate result files in RESULT_DIR.
- JOB_ID_classifications.tsv
- JOB_ID_report.tsv
- JOB_ID_krona.html
```
## Reformatting
Metabuli doesn't calculate score for each taxonomic rank.
It just reports classification scores calculated based on the sequence similarities of matched regions.
For this challenge, the scores are printed as scores for each taxon, all taxa along the lineage having the same score.

```bash
metabuli ictv-format JOB_ID_classifications.tsv
```
It will generate a file named "JOB_ID_classifications_ictv.csv".




