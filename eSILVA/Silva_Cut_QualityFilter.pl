#!/usr/bin/perl -w
use strict;
use warnings;
use Bio::SeqIO;
use Getopt::Long;

=head1  NAME

	Silva_Cut_QualityFilter.pl 

=head1 PURPOSE

	script used to cut Silva seqs according to alignment boundary, and remove poorly aligned and chimeric sequences

=head1 USAGE

	Silva_Cut_QualityFilter.pl -i <input_Silva.fasta> -o <output_Silva.fasta> -quality <75> -pintail <100>

=head1 INPUT

=head2 input_Silva.fasta

	Fasta file with header created by ARB with fasta_ref111.eft filter:

	LSU
	---------------------------------------------------------
	>AAAA02045240.678.2192 |organism=Oryza sativa Indica Group| |strain= | |cut-head=0| |cut-tail=0| |alignment-quality=99| |pintail=0| |arb_name=OrySati3| |environmental-sample=| |isolation-source=| |tax_embl=Eukaryota;Viridiplantae;Streptophyta;Embryophyta;Tracheophyta;Spermatophyta;Magnoliophyta;Liliopsida;Poales;Poaceae;BEP clade;Ehrhartoideae;Oryzeae;Oryza;| |tax_embl_name=Oryza sativa Indica Group|  |tax_gg=| |tax_gg_name=| |tax_rdp=Unclassified;| |tax_rdp_name=Oryza sativa Indica Group| |tax_slv=Bacteria;Bacteroidetes;Flavobacteria;Flavobacteriales;Flavobacteriaceae;Flavobacterium| |tax_ltp=Unclassified;| |tax_ltp_name=Oryza sativa Indica Group| 
	AGAGUUUGAUCCUGGCUCAGGAUGAACG...
	---------------------------------------------------------

	SSU
	---------------------------------------------------------
	>AAAA02000650.3871.6664 |organism=Oryza sativa Indica Group| |strain= | |cut-head=0| |cut-tail=0| |alignment-quality=99| |pintail=| |arb_name=OrySativ| |environmental-sample=| |isolation-source=| |tax_embl=Eukaryota;Viridiplantae;Streptophyta;Embryophyta;Tracheophyta;Spermatophyta;Magnoliophyta;Liliopsida;Poales;Poaceae;BEP clade;Ehrhartoideae;Oryzeae;Oryza;| |tax_embl_name=Oryza sativa Indica Group|  |tax_gg=| |tax_gg_name=| |tax_rdp=| |tax_rdp_name=| |tax_slv=Bacteria;Cyanobacteria;Chloroplast| |tax_ltp=| |tax_ltp_name=| 
	UCAAAAGAGGAAAGGCUUGCGGUGGAUAC...
	---------------------------------------------------------

=head1 OUTPUT

=head2 to screen

	---------------------------------------------------------
	accession quality poor alignment quality!
	accession pintail poor sequence quality!
	...
	Out of 29306 sequences:
	 3579 sequences with poor alignment and 0 possibly chimeric sequences (low pintail) were taken out.
	 3607 sequences were kept and edited to remove unaligned ends.
	 22120 sequences were kept as they were.
	---------------------------------------------------------	

=head1 AUTHOR

	Kasia Zaremba, Katarzyna.Zaremba.Niedzwiedzka@gmail.com

=cut

my $File 	= '';
my $NewFile 	= '';
##maximal similarity to reference sequence in the seed
my $alignment_quality_threshold	= 75;
##information about potential sequence anomalies detected by Pintail (Ashelford et al 2005. AEM. 71:7724-7736.); 100 means no anomalies found.
my $pintail_threshold		= 100;

GetOptions(
    	'i|infile=s'  	=> \$File,
    	'o|outfile=s' 	=> \$NewFile,
	'quality=i'  	=> \$alignment_quality_threshold,
	'pintail=i'  	=> \$pintail_threshold,
);

unless ( $File && $NewFile ) {
    exec( 'perldoc', $0 );    # exec exits this program automatically
}

my $fasta_in = Bio::SeqIO->new(-file => "$File",
				-format => 'fasta');
my $all = 0;
my $out_alignment = 0; my $out_pintail = 0; my $out_taxonomy = 0; my $edited = 0; my $perfect = 0;
open my $OUT, '>', $NewFile or die "could not open $NewFile to write";
DATABASE:while ( my $seq = $fasta_in->next_seq() ) {
	my $accession = $seq->display_id;
	if ( $seq->desc =~ /\|cut-head=(\d+)\| \|cut-tail=(\d+)\| \|alignment-quality=(\d+)\| \|pintail=(\d*)\| / ) {
		my $head=$1; my $tail=$2; my $quality=$3; my $pintail=$4;
		#if not defined, make it artificially high to meet the condition
		$pintail = 1000 if ( $pintail eq "" );
		#print "head $head tail $tail quality $quality pintail $pintail\n";
		$all += 1;
		if ( $quality >= $alignment_quality_threshold && ( $pintail >= $pintail_threshold ) ) {
			print $OUT ">",$seq->display_id," ",$seq->desc,"\n";
			my $sequence = $seq->seq;
			if ( $head != 0 || $tail != 0 ) {
				$edited += 1;
				my $length = length($sequence) - $head - $tail;
				my $new_sequence = substr($sequence,$head,$length);
				print $OUT "$new_sequence\n";
			}
			else {
				$perfect += 1;
				print $OUT "$sequence\n";
			}
		}
		else {
			if ( $quality < $alignment_quality_threshold ) 	{ $out_alignment+=1; print "$accession $quality poor alignment quality!\n"; }
			else						{ $out_pintail+=1; print "$accession $pintail poor sequence quality!\n"; }
		}
	}
	else {
		print "Parsing error $accession with ",$seq->desc,"\n";
	}
}

print "Out of $all sequences:\n $out_alignment sequences with poor alignment and $out_pintail possibly chimeric sequences (low pintail) were taken out.\n $edited sequences were kept and edited to remove unaligned ends.\n $perfect sequences were kept as they were.\n";

