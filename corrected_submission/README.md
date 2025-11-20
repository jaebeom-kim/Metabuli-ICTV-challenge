# Corrected Submission
## The reason for the corrected submission
### Some known families were completely missing in Metabuli's database
While inspecting the Figure 4 of the draft mansucript, I noticed Metabuli showed low accuracies for some viral Families.
For Abyssoviridae, Metaviridae, Pseudoviridae, Belpaoviridae families, the accuracies were zero or near zero.
I checked those families in `VMR_MSL39.v4_20241106` file and found that they have 1, 31, 33, and 11 Genbank accessions, respectively.
However, when I checked Metabuli's database used for the submission, I found that 0, 2, 0, and 0 accessions were present for those families, respectively. Afterward, I checked how many 19,769 accessions of `VMR_MSL39.v4_20241106` were present in Metabuli's database and found that only 17,963 (90.8%) accessions were present. This low coverage of the database might have affected the accuracies of Metabuli for some viral families. Therefore, I decided to build a new Metabuli database with higher coverage of `VMR_MSL39.v4_20241106` and submit the results again.

## The reason for low coverage of the previous Metabuli database
1. I downloaded viral GenBank assemblies using `download_genbank_genomes.sh` script in root directory of this repo. This script downloads files suffixed with `genomic.fna.gz`. Out of all downloaded sequences, only those sequences of accessions present in `VMR_MSL39.v4_20241106` were used to build the database.
However, the downloaded sequences did not include all accessions present in `VMR_MSL39.v4_20241106`, which caused low coverage of the database.
2. The `Virus GENBANK accession` column in `VMR_MSL39.v4_20241106` cotains some values in unexpected fomrat, which resulted in failure to retrieve those sequences. 

## How the new Metabuli database was built

### Downloading GenBank accessions
I used `https://www.ncbi.nlm.nih.gov/sites/batchentrez` to retreive all 19,769 accessions present in `VMR_MSL39.v4_20241106` file.
It downloaded 19,766 sequences in a single fasta file, missing 3 accessions: `JAEILC010000038`, `GECV01031551`, and `AUXO017923253`.
The site reported that those accession names were wrong. 

### Building the new Metabuli database

#### Prepare required files
For taxonomy dump files, I used the same files as in the previous submission, which were in `TAXONOMY_DIR` directory.
For accession to taxid mapping file, I used `prepare-accession2taxid-improved.sh` script, which was improved to better handle unexpected formats in `Virus GENBANK accession` column of `VMR_MSL39.v4_20241106` file. 
```bash
prepare-accession2taxid-improved.sh TAXONOMY_DIR
```
It generated `TAXONOMY_DIR/ictv.accession2taxid` file.

#### Build the database
The same Metabuli version (v1.0.9) as in the previous submission was used to build the database.
```bash
#FASTA_FILE_LIST contains a single path to the downloaded fasta file.
metabuli add-to-library FASTA_FILE_LIST TAXONOMY_DIR/ictv.accession2taxid DBDIR --taxonomy-path TAXONOMY_DIR
find DBDIR/library -name "*.fna" > library-files.txt
metabuli build DBDIR library-files.txt TAXONOMY_DIR/ictv.accession2taxid --taxonomy-path TAXONOMY_DIR
```

## Results with the new Metabuli database
I used the same classification command as in the previous submission to classify the merged query sequences.


## Comparison between the previous and new results
When comparing old and new results with default parameters, 4606 sequences (7.7% of total) were classified differently.
For those sequences, the average confidence scores of classifications were increased from 0.44 to 0.70, indicating that the new database improved the classification quality. Moreover, 1,029 sequences changed from unclassified to classified, while only 145 sequences changed from classified to unclassified.
