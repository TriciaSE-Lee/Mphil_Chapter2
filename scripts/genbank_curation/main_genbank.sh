#!/bin/bash

# Inputs
INPUT_FILE=$1   #GCF_priority_output.tsv
QUERY_FILE=$2   #assembly_summary_genbank_edited.tsv
PRE=$3          #genbank

#-------------------- FILES OF NOTE --------------------------#
# genbank_results = compiled batch grepped genbank metadata
# genbank_results_fixed = Filled in NA for empty columns
# genbank_results2 = cut out columns of interest from genbank results
# genbank_input_edited = edited GCF_priority_output file with extra GCA column in $3 and trimmed to only contain columns of interest
# genbank_output = final output file combined of genbank_results2 and genbank_input_edited done through matching of $1 of genbank_results2 and $3 of genbank_input_edited

# Creating separate lists:
head -1 GCF_priority_output.tsv > GCA_only.tsv
head -1 GCF_priority_output.tsv > GCF_only.tsv

# Then grep data lines only
tail -n +2 GCF_priority_output.tsv | grep "GCA_" >> GCA_only.tsv
tail -n +2 GCF_priority_output.tsv | grep "GCF_" >> GCF_only.tsv

# Remove versions to grep for just accessions
csvtk mutate -t -f sgenome -n sgenome_no_version GCA_only.tsv | csvtk replace -t -f sgenome_no_version -p '\.[0-9]+$' -r '' > GCA_no_version.tsv
csvtk mutate -t -f sgenome -n sgenome_no_version GCF_only.tsv | csvtk replace -t -f sgenome_no_version -p '\.[0-9]+$' -r '' > GCF_no_version.tsv

#--------------------batch.sh-------------------#

# Split list into chunks of 1000 in respective "batches" directory
mkdir -p batches_GCA
tail -n +2 GCA_only.tsv | split -l 1000 - batches_GCA/batch_        # Remove header for batching
mkdir -p batches_GCF
tail -n +2 GCF_only.tsv | split -l 1000 - batches_GCF/batch_ 

#------------- RUN CODE ------------------#
#./batch.sh GCA_priority_output.tsv assembly_summary_genbank_edited.tsv genbank

#--------------------metadata_batches.sh----------------------#

# Loop through batches
# Adding an exit code for grep so that it prints a fallback line if it finds nothing.

BATCH=$1
QUERY_FILE=$2

#GCA - GCA_grep.sh
while IFS=$'\t' read -r line; do
    sgenome=$(echo "$line" | awk -F'\t' '{print $22}')
    result=$(grep -P "^$sgenome\t" "$QUERY_FILE")
    if [[ -n "$result" ]]; then
        echo "$result" >> "$BATCH"_results.tsv
    else
        echo -e "$sgenome\tNA\tNA\tNA" >> "$BATCH"_results.tsv
    fi
done < "$BATCH"


#GCF - GCF_grep.sh
awk -F'\t' -v OFS='\t' '
    # Load query file into lookup array
    NR==FNR {
        lookup[$18] = $0
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


# Changed to produce a result file for each as when printing to just one file seem like some were lost in the process

#------------- RUN CODE ------------------#
#for batch in batches_GCA/batch_*; do ssubmit -t 1h -m 1g "${batch}_grep" "bash metadata_batches.sh $batch assembly_summary_genbank_edited.tsv genbank"; done
#for batch in batches_GCF/batch_*; do ssubmit -t 1h -m 1g "${batch}_grep" "bash metadata_batches.sh $batch assembly_summary_genbank_edited.tsv genbank"; done



#-----------------Checks--------------------#
# Number of isolates per batch - should be 1000 except last one
wc -l batches/*

#--------------------------------------------------------#

# Paste header for results file for both GCA and GCF
head -1 $QUERY_FILE > "$PRE"_results.tsv

# Parse all result files from the batches into result file (separately)
# GCA - GCA_results.tsv
for batch in batches_GCA/batch_*_results.tsv
    do cat ${batch} >> GCA_results.tsv
done

# GCF - GCF_results.tsv
for batch in batches_GCF/batch_*_results.tsv
    do cat ${batch} >> GCF_results.tsv
done

# Fill in all columns that are empty with NA

NCOLS=$(head -1 "$PRE"_results.tsv | awk -F'\t' '{print NF}')
awk -F'\t' -v OFS='\t' -v ncols=$NCOLS '
{
    for (i=NF+1; i<=ncols; i++) $i = "NA"
    print
}' "$PRE"_results.tsv > "$PRE"_results_fixed.tsv

# Using csvtk to cut out columns of interest from results file and input file

#GCA
csvtk cut -t --lazy-quotes -f assembly_accession,bioproject,biosample,species_taxid,organism_name,infraspecific_name,isolate,assembly_level,genome_rep,gbrs_paired_asm,genome_size,genome_size_ungapped,replicon_count,scaffold_count,contig_count,annotation_name,seq_rel_date GCA_results_fixed.tsv > GCA_results2.tsv

#GCF - replacing the gbrs_paired_asm column with the assembly_accession
csvtk cut -t --lazy-quotes -f gbrs_paired_asm,bioproject,biosample,species_taxid,organism_name,infraspecific_name,isolate,assembly_level,genome_rep,gbrs_paired_asm,genome_size,genome_size_ungapped,replicon_count,scaffold_count,contig_count,annotation_name,seq_rel_date GCF_results_fixed.tsv > GCF_results2.tsv

# combining both
cat GCA_results2.tsv >> genbank_results2.tsv
tail -n +2 GCF_results2.tsv >> genbank_results2.tsv

# cutting columns from input file
csvtk cut -t -f query,sgenome,sseqid,qcovGnm,qcovHSP,pident,gaps,qstart,qend,sstart,send,slen GCF_priority_output.tsv > GCF_priority_output_edited.tsv
csvtk mutate -t -f sgenome -n sgenome_no_version GCF_priority_output_edited.tsv | csvtk replace -t -f sgenome_no_version -p '\.[0-9]+$' -r '' > genbank_input_edited.tsv

# Adding in GCA column first before cutting out columns of interest
# csvtk mutate -t -f sgenome -n sgenome_gca GCF_priority_output.tsv | csvtk replace -t -f sgenome_gca -p 'GCF_' -r 'GCA_' | csvtk cut -t -f query,sgenome,sgenome_gc
# a,sseqid,qcovGnm,qcovHSP,pident,gaps,qstart,qend,sstart,send,slen > genbank_input_edited.tsv

# Adding just accession without version for matching with awk
csvtk mutate -t -f assembly_accession -n sgenome_no_version genbank_results2.tsv | csvtk replace -t -f sgenome_no_version -p '\.[0-9]+$' -r '' > genbank_results3.tsv

# Reorgansing into output file
awk -F'\t' -v OFS='\t' '
    NR==FNR {
        if (FNR==1) {
            for (i=2; i<=NF; i++) header = header (i>2 ? OFS : "") $i
            next
        }
        val = ""
        na  = ""
        for (i=2; i<=NF; i++) {
            val = val (i>2 ? OFS : "") $i
            na  = na  (i>2 ? OFS : "") "NA"
        }
        sam[$18] = val
        na_str  = na
        next
    }
    FNR==1  { print $0, header; next }
    {
        key = $13
        print $0, (key in sam ? sam[key] : na_str)
    }
' "$PRE"_results3.tsv "$PRE"_input_edited.tsv > "$PRE"_output.tsv




























# Issue with some grep of GCA being the wrong version as when converting the GCF which is for example the first version led to the grep of the genbank first version when in reality its the second genbank version and first refseq version.
# To fix this, attempting to query separate input files of just GCA and just GCF taken from the GCF_priority_output.tsv list. 

# Creating separate lists:
head -1 GCF_priority_output.tsv > GCA_only.tsv
head -1 GCF_priority_output.tsv > GCF_only.tsv

# Then grep data lines only
tail -n +2 GCF_priority_output.tsv | grep "GCA_" >> GCA_only.tsv
tail -n +2 GCF_priority_output.tsv | grep "GCF_" >> GCF_only.tsv




# The matching needs to be the stripped numerals or else the GCF accessions will not match the sam array that has the GCA ones as the assembly accession. 
# Either that or go back to the sorting of the list and give GCA priority to be kept over the GCF - create new list. - did this


# Ammending this above

# awk -F'\t' -v OFS='\t' '
#     NR==FNR { sam[$1] = $2; next }                    # This is what is ammended - the sam array block
#     FNR==1  { print $0, "sample_accession"; next }
#     { print $0, ($1 in sam ? sam[$4] : "NA") }
# ' "$PRE"_results.tsv "$PRE"_input_edited.tsv > $OUTPUT_FILE



# Using csvtk to append column without matching
# csvtk paste -t $INPUT_FILE "$PRE"_results.tsv > "$PRE"_output.tsv



# Append to original csv using awk matching
# awk -F'\t' -v OFS='\t' '
#     NR==FNR { sam[$1] = $2; next }
#     FNR==1  { print $0, "sample_accession"; next }
#     { print $0, ($4 in sam ? sam[$4] : "NA") }
# ' results.tsv $INPUT_FILE > $OUTPUT_FILE