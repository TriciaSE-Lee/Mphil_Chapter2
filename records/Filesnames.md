# Filename and database states:
##### PLSDB (n=963 at ichsm)
1. `plsdb_final.tsv` = unique as per sgenome ID and query
2. `plsdb_ichsm.tsv` = plsdb_final with bioproject appended as sample_accession

---
##### Refseq Genbank (n=29133 at final)
1. `refseq_final.tsv` = unique as per deduplicated with GCF/GCA sgenome with <mark>GCF</mark> taking priority sorted by natural string by csvtk
    - Used the refseq lexicmap query unique `incx3_pir_refseq_results_unique.tsv`
    - Stripped GCF/GCA and sorted and kept unique numerals along with query identity. 
    - Resorted `GCF_priority_output.tsv` and `GCA_priority_output.tsv` by **pident**
2. `genbank_grep.tsv` =  file containing the columns of interest from the grep of the genbank metadata txt file. This file has gone through the manual curation of accessions that returned NA for bioproject - it is the final list for genbank. 
    - To note: There are <mark>duplicates</mark> from the double hits with query
    - There are also duplicates in terms of biosamples with single biosamples having multiple assembly accessions (need to deduplicate based on several things - assembly level, sequencing read type (LR v SR), completeness - maybe?)
3. `genbank_grep_dedup.tsv` = Final list that contains the unique biosamples that are filtered and kept based on listing order - of assembly quality (assembly_level, read_type= Hybrid v LR v SR, smaller contig numbers then largest N50 if needed to break any more ties.)




