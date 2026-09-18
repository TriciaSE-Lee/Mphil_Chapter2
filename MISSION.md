# Mission: awk, sed, and regex for bioinformatics data wrangling

## Why
Tricia is running the IncX3 plasmid pangenome analysis for MPhil Chapter 2 — querying AllTheBacteria, downloading assemblies, comparing reference sequences, and generating tabular output from tools like lexicmap and minimap2. Right now, cleaning up filenames, FASTA headers, and tool output is done by hand or with ad-hoc one-off commands. Learning awk/sed/regex properly turns "I'll rename these 40 files individually" into a five-second command, and turns "eyeball this TSV for the row I want" into a repeatable, checkable pipeline.

## Success looks like
- Batch-rename a directory of downloaded assembly/genome files using `sed` inside a loop, without hand-editing each name.
- Write a regex that correctly matches accession numbers, sequence IDs, or other structured tokens in real ATB/plasmidfinder output, and explain why it doesn't over- or under-match.
- Use `awk` to filter, extract, and reformat columns from tabular tool output (e.g. lexicmap or minimap2 results) without opening the file in Excel or a text editor.
- Read someone else's short awk/sed one-liner (e.g. from a forum or a labmate) and correctly predict what it does before running it.

## Constraints
- Comfortable with bash already (piping, redirection, loops) — lessons should build on that, not re-teach it.
- New to awk, sed, and regex specifically — some prior regex-adjacent exposure is not assumed.
- Prefers short lessons spread across many sessions over a single long crash course.
- Learning happens alongside active MPhil research — real filenames and real file formats from the IncX3 work should ground examples wherever possible.

## Out of scope
- Full awk as a general-purpose programming language (control flow, functions, arrays) — only as much as is needed for tabular bioinformatics data wrangling, unless a real task demands more later.
- Perl-compatible regex extensions (lookaheads, non-greedy quantifiers, etc.) — basic regex first; revisit if a real task needs them.
- GUI find-and-replace tools — the mission is specifically command-line fluency.
