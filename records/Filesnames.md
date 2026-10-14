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
3. `genbank_grep_cleaned.tsv` = file containing the columns: query, sgenome, bioproject, biosample, organism_name, assembly_level, seq_rel_date, sgenome_no_version



