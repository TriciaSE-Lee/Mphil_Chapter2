#!/bin/bash

BATCH=$1
QUERY_FILE=$2

# Loop through batches
# Adding an exit code for grep so that it prints a fallback line if it finds nothing.

#GCA
while IFS=$'\t' read -r line; do
    sgenome=$(echo "$line" | awk -F'\t' '{print $22}')
    result=$(grep -P "^$sgenome" "$QUERY_FILE")
    if [[ -n "$result" ]]; then
        echo "$result" >> "$BATCH"_results.tsv
    else
        echo -e "$sgenome\tNA\tNA\tNA" >> "$BATCH"_results.tsv
    fi
done < "$BATCH"

#------------- RUN CODE ------------------#
#for batch in batches_GCA/batch_*; do ssubmit -t 1h -m 1g "${batch}_grep" "bash GCA_grep.sh $batch ../metadata/assembly_summary_genbank_edited.tsv genbank"; done