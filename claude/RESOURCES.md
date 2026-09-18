# awk, sed, and regex — Resources

## Knowledge

- [GNU sed manual](https://www.gnu.org/software/sed/manual/sed.html)
  The authoritative reference for every `sed` command and flag. Dense — use it to look up exact syntax once a lesson has already introduced the concept, not to learn from cold.
- [The Grymoire: Sed — An Introduction and Tutorial](https://www.grymoire.com/Unix/Sed.html) / [Sed Quick Reference](https://www.grymoire.com/Unix/SedRef.html)
  Widely regarded as the best plain-English `sed` tutorial on the web; the quick reference is good for a one-page recap. Use for: understanding *why* `sed` commands are shaped the way they are.
- [The Grymoire: Awk — A Tutorial and Introduction](https://www.grymoire.com/Unix/Awk.html) / [Awk Quick Reference](https://www.grymoire.com/Unix/AwkRef.html)
  Same author, same quality, for `awk`. Use for: fields, records, `-F`, and pattern-action structure.
- [Data Carpentry: Introduction to the Command Line for Genomics](https://datacarpentry.github.io/shell-genomics/)
  Built specifically for people doing exactly Tricia's kind of work — teaches `grep`/regex/pipelines against real FASTQ/genomics data. Use for: grounding regex and text tools in genomics file formats specifically.
- [Chapter 6: Sed, awk, and regular expressions — *Practical Computing and Bioinformatics for Conservation and Evolutionary Genomics*](https://eriqande.github.io/eca-bioinf-handbook/sed-awk-and-regular-expressions.html)
  A full chapter aimed at exactly this mission (bioinformatics researcher, command line, real data). Use for: worked examples close to genomic data wrangling.
- [RegexOne](https://regexone.com/)
  Short, interactive, beginner-friendly regex lessons with instant feedback. Use for: basic regex tokens and syntax practice, independent of any particular tool.

## Wisdom (Communities)

- [Biostars](https://www.biostars.org/) — tag: [command-line](https://www.biostars.org/tag/command-line/)
  The main bioinformatics Q&A forum; strong moderation, high signal. Use for: "is there a better way to do X with real genomics files" questions, and reading how experienced bioinformaticians phrase one-liners.
- [Unix & Linux Stack Exchange](https://unix.stackexchange.com/)
  General-purpose but very high quality for `sed`/`awk`/regex specifics that aren't genomics-related. Use for: syntax and edge-case questions.

## Gaps

- No community identified yet specifically for *awk/sed one-liner review* (as opposed to general bioinformatics Q&A). Revisit if Biostars proves too broad.
