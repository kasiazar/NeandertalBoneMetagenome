NeandertalBoneMetagenome
========================

Storage for files and scripts for the Neandertal bone metagenome project.

More description at: /sites.google.com/site/kzarembaniedzwiedzka/NeandertalBoneMicrobes

eSILVA
========================

===rRNA database 

eSilvaRef111NR.fasta[.tgz] - rRNA

eSSU_SilvaRef111NR.fasta[.tgz] - SSU

eLSU_SilvaRef111.fasta[.tgz] - LSU

eSilvaRef111NR.n*, eSilvaRef111NR.n.tgz - prepared with formatdb (Version 2.2.18 [Mar-02-2008]) for blast

===Script to make eSILVA

Make_eSILVA.sh - wrapper with step by step description

Silva_Cut_QualityFilter.pl - remove poor quality

Silva_Ref111_Filter.pl - remove poor taxonomy

fasta_ref111.eft - arb filter

Description: Custom high quality rRNA database, made removing poor quality or chimeric sequences, cutting unaligned ends, and removing taxonomically problematic sequences. To be used with the corresponding parser (to be added soon).


Assembly
========================

===SSU

======Metazoa

=========assembly

=========phd_dir

=========chromat_dir

======Streptomyces

...

===LSU

...

consed_[S|L]SU_[Metazoa|Streptomyces].tgz - files for viewing in consed; intermediate substiution calculation files.

[S|L]SU/[Metazoa|Streptomyces]/assembly

[Metazoa|Streptomyces].fasta.screen.ace.1 - ace file to be opened in consed

intermediate files for subsitution calculations:

[Metazoa|Streptomyces].C\d+.ace.1 - separated ace for one contig

[Metazoa|Streptomyces].C\d+.ace.1.consensus - corrected consensus sequence

[Metazoa|Streptomyces].C\d+.ace.1.details - all differences for all reads

[Metazoa|Streptomyces].C\d+.ace.1.reads - reads sequences with matching read position to consensus position

Description:
Assembly results available for viewing in consed (go to assembly folder). Substitution calculations were done in several steps. First consensus sequence was verified by checking the dominant base at each position. Then all differences between the reads and consensus were calculated. Subsequent summary script implemented a cleaning procedure to overcome problem with adaptor leftovers at the ends: ignore end until 5bp are identical with consensus. To ignore reads that could be assembly errors all reads with more than 5 changes in total were discarded as well (not many). To inspect the difference between all difference and the calculated onces see the html pages below.


Streptomycineae.C11.ace.1.details.ReadsDiscrepantSummerize_end5_rm5.skipped_too_many_substitutions

Streptomycineae.C11.ace.1.details.ReadsDiscrepantSummerize_end5_rm5.all_reads

Description:
For calculations of diversity within C11. All read include the ones that were skipped due to more than 5 changes in 1 read (21). These are reads left after the cleaning procedure that takes care of problematic ends (adaptor leftovers). It of course reduces the ancient damage signal, BUT in Nenadertal contigs the signal is still very strong. And in any case, results that inluce all changes is not the typical ancient C --> T.


ContigsHtml
========================

tgz: ContigsHtml_v1.tgz

start at: ContigsList.html 

assemblies: [LS]SU*end0.html

susbtitutions: [LS]SU*end5.rm5.html

Description:
These files were generated to inspect the assembly results. The script generating the html page marked in black all positions that disagree with the consensus (end0). To inspect the subsitution calculations, the script marks the positions in black, but applying certain cleaning procedure. That is ignore the ends until 5 consecutive bp agree with the consensus (potential adaptor leftovers) and ignore reads that have overall more that 5 subsitutions (occasional polymorphic or misassembled read). 


Alignments
========================

Pseudonocardia2_blocks2*

Propionibacteria2_blocks1*

Streptomyces3_blocks3*

Description:
These alignment blocks were used for phylogenies, with the purpose of inspecting whether sediment clones (PCR amplified with bacterial universal primers 27f and 1492r, as well as actinobacterial primers) will place as sister groups to any of the bone consensus sequences. In case you wonder: they dont. Name conversion file available for each to match alignment (short names for processing with RAXML) to the tree (nicer names for reading).

