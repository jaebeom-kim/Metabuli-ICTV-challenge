# Metabuli-ICTV-challenge

## Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Database preparation](#database-preparation)
4. [Classification](#classification)
5. [Reformatting](#reformatting)
6. [Results](#results)

## Introduction
***[Metabuli](https://github.com/steineggerlab/Metabuli)*** classifies metagenomic reads by comparing them to reference genomes. You can use Metabuli to profile the taxonomic composition of your samples or to detect specific (pathogenic) species. 

***Sensitive and Specific.*** Metabuli uses a novel k-mer structure, called *metamer*, to analyze both amino acid (AA) and DNA sequences. It leverages AA conservation for sensitive homology detection and DNA mutations for specific differentiation between closely related taxa.

***A laptop is enough.*** Metabuli operates within user-specified RAM limits, allowing it to search any database that fits in storage. A PC with 8 GiB of RAM is sufficient for most analyses.

***A few clicks are enough.*** Metabuli App is now available [here](https://github.com/steineggerlab/Metabuli-App). With just a few clicks, you can run Metabuli and browse the results with Sankey and Krona plots on your PC.

***Short reads, long reads, and contigs.*** Metabuli can classify all types of sequences.

---

For more details, please see
[Nature Methods](https://www.nature.com/articles/s41592-024-02273-y), 
[PDF](https://www.nature.com/articles/s41592-024-02273-y.epdf?sharing_token=je_2D5Su0-xVOSjuKSAXF9RgN0jAjWel9jnR3ZoTv0M7gE7NDF_xi_3sW8QdRiwfSJNwqaXItSoeCvr7cvcoQxKLt0oROgWc6urmki9tP80cXEuHPN0D7b4y9y3i8Yv7sZw8MxxhAj7W6p9eZE2zaK3eozdOkXvwADVfso9cXIM%3D), 
[bioRxiv](https://www.biorxiv.org/content/10.1101/2023.05.31.543018v2), or [ISMB 2023 talk](https://www.youtube.com/watch?v=vz2fuRcVwyk).

Please cite: [Kim J, Steinegger M. Metabuli: sensitive and specific metagenomic classification via joint analysis of amino acid and DNA. Nature Methods (2024).](https://doi.org/10.1038/s41592-024-02273-y)

## Installation
Please refer to the [Metabuli repository](https://github.com/steineggerlab/Metabuli) to install the software.
Pre-built binaries and bioconda packages are available.
You don't need any other dependencies if you use a [pre-built database](https://hulk.mmseqs.com/jaebeom/vmr39.4/) to reproduce the results.

---

We also provide [Metabuli App](http://github.com/steineggerlab/Metabuli-App) for user-friendly graphical interface to run the taxonomic classification and result visualization. But it is not used for this challenge.



## Database preparation
You can download the database used for this challenge [here](https://hulk.mmseqs.com/jaebeom/vmr39.4/).
It was built using genbank genomes and MSL39.4 taxonomy.


Please follow the instructions below if you want to build your own database.
In this case, you need to install `csvtk` and `taxonkit` to prepare the ICTV taxonomy dump files.

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

## Results
You can find the results following the challenge format in "results" directory.
Fields without values are left blank, not filled with NA.
- `default...csv` : Results from the default mode
  - `--seq-mode 1`
- `default_0.9...csv` : Results from the default mode with more frequent LCA calculation
  - `--seq-mode 1 --tie-ratio 0.9`
- `precise-s...csv` : Results from the precise mode optimized for short reads
  - `--seq-mode 1 --min-score 0.15 --min-sp-score 0.5`
- `precise-s_0.9...csv` : Results from the precise mode optimized for short reads with more frequent LCA calculation
  - `--seq-mode 1 --min-score 0.15 --min-sp-score 0.5 --tie-ratio 0.9`
- `precise-l...csv` : Results from the precise mode optimized for long reads
  - `--seq-mode 1 --min-score 0.07 --min-sp-score 0.3`
- `precise-l_0.9...csv` : Results from the precise mode optimized for long reads with more frequent LCA calculation
  - `--seq-mode 1 --min-score 0.07 --min-sp-score 0.3 --tie-ratio 0.9`






