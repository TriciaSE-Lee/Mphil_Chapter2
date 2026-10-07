# Filename and database states:
##### PLSDB (n=963 at ichsm)
1. `plsdb_final.tsv` = unique as per sgenome ID and query
2. `plsdb_ichsm.tsv` = plsdb_final with bioproject appended as sample_accession

---
##### Refseq Genbank (n=29133 at final)
1. `refseq_final.tsv` = unique as per deduplicated with GCF/GCA sgenome with GCF taking priority
    - Used the refseq lexicmap query unique `incx3_pir_refseq_results_unique.tsv`
    - Stripped GCF/GCA and sorted and kept unique numerals along with query identity. 
2. `refseq_ichsm.tsv` = refseq_final with bioproject appended as sample_accession 



