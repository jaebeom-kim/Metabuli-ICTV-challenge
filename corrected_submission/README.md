# Corrected Submission
## The reason for the corrected submission
> Summary: Metabuli's database used for the submission included 17,963 out of 19,769 accessions (90.8%) present in `VMR_MSL39.v4_20241106` file, representing 13,253 out of the 14,558 species with accession records (91.0%). The missing accession caused impaired accuracies for some viral families in Figure 4 and 5. 

### Some known families were completely missing in Metabuli's database
In the Fig. 4 and 5 of the manuscript, Metabuli showed low accuracy specifically for ten families.
Nine of them have GenBank accessions in `VMR_MSL39.v4_20241106` file except for Polydnaviriformidae.
However, we found that six of those nine families were completely missing in the Metabuli database used for the submission.
For Metaviridae, only 2 out of 31 provided accessions were in the database.
For those seven families, we summarized the accession count differeneces between `VMR_MSL39.v4_20241106` file and the Metabuli database.

| Family | MSL39.4 | Metabuli DB |
| :--- | :--- | :--- |
| Abyssoviridae         | 1 | 0 |
| Pseudoviridae         | 33 | 0 |
| Belpaoviridae         | 11 | 0 |
| Rhodogtaviriformidae  | 4 | 0 |
| Brachygtaviriformidae | 1 | 0 |
| Bartogtaviriformidae  | 1 | 0 |
| Metaviridae           | 31 | 2 |


<!-- While inspecting the Figure 4 of the draft mansucript, I noticed Metabuli showed low accuracies for some viral Families.
For Abyssoviridae, Metaviridae, Pseudoviridae, Belpaoviridae families, the accuracies were zero or near zero.
I checked those families in `VMR_MSL39.v4_20241106` file and found that they have 1, 31, 33, and 11 Genbank accessions, respectively.
However, when I checked Metabuli's database used for the submission, I found that 0, 2, 0, and 0 accessions were present for those families, respectively.  -->
Afterward, we checked how many of 19,769 accessions in `VMR_MSL39.v4_20241106` were present in the Metabuli database and found that only 17,963 (90.8%) accessions were present. This low coverage of the database might have affected the accuracies of Metabuli for some viral families. Therefore, we decided to build a new Metabuli database with higher coverage of `VMR_MSL39.v4_20241106` and submit the results again.


## The reason for low coverage of the previous Metabuli database
1. We downloaded viral GenBank assemblies using the `download_genbank_genomes.sh` script in this repository. The script downloads GenBank files with the suffix `genomic.fna.gz`. From all the downloaded sequences, only those with accessions listed in `VMR_MSL39.v4_20241106` were used to build the database.
However, not all accessions present in `VMR_MSL39.v4_20241106` were included among the downloaded sequences, which resulted in low database coverage.

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

## Classification with the new Metabuli database
We used the same Metabuli version and classification command as in the previous submission to classify the query sequences.


## Comparison between the previous and new results
We compared the classification results obtained using the previous Metabuli database and the new one. Out of six different parameter sets tested, we focused on the default parameters for comparison. 

With the new database, classification results of 4,606 sequences (7.7% of total) differed from those obtained with the previous database. For the changed results, the average confidence scores for classified sequences were increased from 0.44 to 0.70, indicating that the new database improved the classification quality. Moreover, 1,029 sequences changed from unclassified to classified, while only 145 sequences changed from classified to unclassified.

For the seven families analyzed above, we compared the number of classifications to each family between the previous and new results.
Average confidence scores are shown in parentheses.
| Family | Original | Corrected |
| :--- | :--- | :--- |
| Abyssoviridae         | 0 | 3   (0.84) |
| Pseudoviridae         | 0 | 101 (0.80) |
| Belpaoviridae         | 0 | 33  (0.82) |
| Rhodogtaviriformidae  | 0  | 348 (0.04) |
| Brachygtaviriformidae | 0  | 235 (0.02) |
| Bartogtaviriformidae  | 0  | 69  (0.05) |
| Metaviridae           | 15 (0.34) | 93  (0.82) |

## Fairness of the corrected submission
We understand that submitting corrected results after the deadline may raise concerns about fairness. 
However, we only used GenBank accessions provided in the `VMR_MSL39.v4_20241106` file to build the Metabuli database for the corrected submission.
The same Metabuli version, database creation commands, and classification commands as in the previous submission were used.
The taxonomy dump files were also the same as in the previous submission.
The only difference was the method of retrieving GenBank accessions from `VMR_MSL39.v4_20241106` file and downloading them.
We believe that the corrected submission is fair, as it adheres to the challenge guidelines and utilizes only the provided data without any external information.


