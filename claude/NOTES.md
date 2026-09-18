# Teaching Notes

- Motivation for learning awk/sed/regex: batch-renaming files and general data wrangling for the IncX3 plasmid pangenome MPhil work (see MISSION.md).
- Prior experience: comfortable with bash (piping, redirection, loops); new to awk, sed, and regex specifically.
- Pacing preference: short, tightly-scoped lessons spread across many sessions — not a crash course. Respect this when deciding how much to pack into one lesson.
- Ground examples in real bioinformatics file shapes where possible (ATB assembly filenames, FASTA headers, tabular output from lexicmap/minimap2/plasmidfinder) rather than generic strings.
- Regex flavor choice: teaching with `sed -E` (extended regex) and `grep -E` throughout, rather than POSIX BRE, so `+`/`?`/`()` don't need backslashes. This transfers more directly to `awk`'s regex syntax and to other languages later. Note this choice in early lessons so it doesn't look like an inconsistency with material she finds elsewhere using BRE.
