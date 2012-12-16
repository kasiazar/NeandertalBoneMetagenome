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

