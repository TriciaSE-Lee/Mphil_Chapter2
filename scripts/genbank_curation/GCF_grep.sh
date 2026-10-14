#!/bin/bash

BATCH=$1
QUERY_FILE=$2

awk -F'\t' -v OFS='\t' '
    # Load query file into lookup array - strip version from col 18 key
    NR==FNR {
        key = $18
        sub(/\.[0-9]+$/, "", key)
        lookup[key] = $0
        next
    }
    # Process batch file
    {
        sgenome = $22
        if (sgenome in lookup) {
            print lookup[sgenome]
        } else {
            print sgenome"\tNA\tNA\tNA"
        }
    }
' "$QUERY_FILE" "$BATCH" >> "$BATCH"_results.tsv

#------------- RUN CODE ------------------#
#for batch in batches_GCF/batch_*; do ssubmit -t 1h -m 1g "${batch}_grep" "bash GCF_grep.sh $batch ../metadata/assembly_summary_genbank_edited.tsv genbank"; done