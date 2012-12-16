
##################
### Release Ref 111 for PLOS One publication on Neandertal bone
##################
### comments
# commands - uncomment to run!


### Download good quality Silva Ref databases for arb. Take Ref NR database for SSU to have less sequences (99% cutoff for clustering)
### http://www.arb-silva.de/no_cache/download/archive/current/ARB_files/
### LSURef_111_SILVA_05_04_12_opt.arb
### SSURef_111_SILVA_NR_98_04_08_12_opt_v2.arb

### CHANGE HERE to suit your directories
RELEASE="Ref111"
rawLSU=LSURef_111_SILVA_05_04_12_opt.arb.ref111.fasta
rawSSU=SSURef_111_SILVA_NR_98_04_08_12_opt_v2.arb.ref111.fasta
LSU="LSU_SilvaRef111"
SSU="SSU_SilvaRef111NR"
SILVA="SilvaRef111NR"

echo "This script requires that you read and uncomment what needs to be run and make appropriate changes to fit your directory structure etc. Currently you are only getting messages but nothing happens. Rel111 is avilable for download - check the repository for e$LSU.fasta, e$SSU.fasta or merged: e$SILVA.fasta"
echo "If you don't know how to make it work do not hesistate to contact me (Katarzyna.Zaremba.Niedzwiedzka@gmail.com) to get the eSILVA version you need! "
echo
echo "FAQ: Why not simply Silva truncated?"
echo "It still contains some tRNA sequences that will cause false positives. See the POne paper supplementary table for lits of accesion numbers (ref coming soon) or [LS]SURef_111_*tax_silva_trunc.G.tRNAscan-SE"
echo "It also contains many sequences whose annotation will only confuse decision making based on hits (uninformatvie metagenomic samples; domain-level disagreements for mitochondria and chloroplasts; ...)"
echo
echo "FAQ: Can I use RDP or Greengenes taxonomy instead of the Silva one?"
echo "Yes. Export filter fasta_ref111.eft keeps information from all available taxonomies and you can use whichever you like in the parsing step. You can also compare them. Planned development: exchange the taxonomy for particular accessions to your own in case you have a more suitable assignment for certain sequences."
echo

echo "Export fasta from ARB with the following filter: fasta_ref111.eft"
echo "that has to be placed in your ARB/lib/export directory"
### CHECK ARBHOME AND LD_LIBRARY_PATH in ~/.bashrc to know where to export the filter
### copy fasta_ref111.eft to lib/export in ARB, in my case:
# cd /home/kasiazar/Tools/ARB/lib/export
# cp /gigant/Databases/rRNA/SILVA/Ref111/fasta_ref111.eft .
# cd -

### in ARB:
### FILE--> EXPORT--> Export sequences to foreign format (Export all) Select a format: F fasta_ref111.eft
### export all, filter none, compress all gaps 
### LSURef_111_SILVA_05_04_12_opt.arb.ref111.fasta
### SSURef_111_SILVA_NR_98_04_08_12_opt_v2.arb.ref111.fasta
### this might take couple of minutes! 

#mkdir $RELEASE
echo "Move exported files to $RELEASE directory"

###################
### FIRST deal with quality
### THEN taxonomy - modify if needed
###################
### OBS! assuming that raw fasta files are in directory

echo "Silva_Cut_QualityFilter.pl takes out poor quality sequences."
echo "Silva_Ref111_Filter.pl     takes out sequences with uninformative taxonomy. Modify for you needs if you like."

#Silva_Cut_QualityFilter.pl -i $RELEASE/$rawLSU -o $RELEASE/$LSU.fasta -quality 75 -pintail 100 > $RELEASE/$LSU.fasta.Silva_Cut_QualityFilter.output"
###Out of 286858 sequences:
### 2763 sequences with poor alignment and 94260 possibly chimeric sequences (low pintail) were taken out.
### 38395 sequences were kept and edited to remove unaligned ends.
### 151440 sequences were kept as they were.

#Silva_Cut_QualityFilter.pl -i $RELEASE/$rawSSU -o $RELEASE/$SSU.fasta -quality 75 -pintail 100 > $RELEASE/$SSU.fasta.Silva_Cut_QualityFilter.output
###Out of 29306 sequences:
### 3579 sequences with poor alignment and 0 possibly chimeric sequences (low pintail) were taken out.
### 3607 sequences were kept and edited to remove unaligned ends.
### 22120 sequences were kept as they were.

### from the headers, modify which sequences to remove based on taxonomy if you like

#Silva_Ref111_Filter.pl -i $RELEASE/$LSU.fasta -o $RELEASE/e$LSU.fasta -lsu -details $RELEASE/e$LSU.fasta.Silva_Ref111_Filter.details > $RELEASE/e$LSU.fasta.Silva_Ref111_Filter.output
###Out of 25727 sequences:
### 57 sequences with no taxonomic information taken out.
### 2334 sequences with disagreing EMBL and Silva first two taxons were taken out, details in Ref111/eLSU_SilvaRef111.fasta.Silva_Ref111_Filter.details.

### not too many taken out - OK!

#Silva_Ref111_Filter.pl -i $RELEASE/$SSU.fasta -o $RELEASE/e$SSU.fasta -ssu -details $RELEASE/e$SSU.fasta.Silva_Ref111_Filter.details > $RELEASE/e$SSU.fasta.Silva_Ref111_Filter.output

###Out of 189835 sequences:
### 8046 sequences with no taxonomic information taken out.
### 9561 sequences with disagreing EMBL and Silva first two taxons were taken out, details in Ref111/eSSU_SilvaRef111NR.fasta.Silva_Ref111_Filter.details.

### some out but not ridiculously hight - OK!

echo "Merge SSU and LSU and turn into blast database with formatdb (assumed to be working)"

#cat $RELEASE/e$LSU.fasta > $RELEASE/e$SILVA.fasta
#cat $RELEASE/e$SSU.fasta >> $RELEASE/e$SILVA.fasta

#ln -s $RELEASE/e$SILVA.fasta
#formatdb -i e$SILVA.fasta -p F -n e$SILVA

echo "Current version of custom Silva database is e$SILVA"
echo "DONE!!!"
echo
echo "(now check if blast works)"
echo "head -n 10 e$SILVA.fasta > test.fasta"
echo "blastall -p blastn -i test.fasta -d e$SILVA > test.blastn.eSILVA"
echo
echo "(compare with test.fasta.check, test.blastn.eSILVA.check if you have doubts)"
echo

