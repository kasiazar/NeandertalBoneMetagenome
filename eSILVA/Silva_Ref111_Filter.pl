#!/usr/bin/perl -w
use strict;
use warnings;
use Bio::SeqIO;
use Getopt::Long;
use List::MoreUtils qw(uniq);

=head1  NAME

	Silva_Ref111_Filter.pl - script used to filter Silva entires

=head1 PURPOSE

	Remove taxonomically uninformative sequences (based on Silva taxonomy), and sequences with domain disagreement in annotation between taxonomies (Silva, EMBL; if available RDP and Greengenes, see subroutine AgreedBasics). Modify the header for compatibility with the parser (see subroutines EditGG and EditRDP).

=head1 USAGE

	Silva_Ref111_Filter.pl -i <input_Silva.fasta> -o <output_Silva.fasta> -ssu|lsu

=head1 INPUT

=head2 input_Silva.fasta

	Fasta file with header created by ARB with fasta_tax_cutoff_quality filter:

	LSU
	---------------------------------------------------------
	>AAAA02045240.678.2192 |organism=Oryza sativa Indica Group| |strain= | |cut-head=0| |cut-tail=0| |alignment-quality=99| |pintail=0| |arb_name=OrySati3| |environmental-sample=| |isolation-source=| |tax_embl=Eukaryota;Viridiplantae;Streptophyta;Embryophyta;Tracheophyta;Spermatophyta;Magnoliophyta;Liliopsida;Poales;Poaceae;BEP clade;Ehrhartoideae;Oryzeae;Oryza;| |tax_embl_name=Oryza sativa Indica Group|  |tax_gg=| |tax_gg_name=| |tax_rdp=Unclassified;| |tax_rdp_name=Oryza sativa Indica Group| |tax_slv=Bacteria;Bacteroidetes;Flavobacteria;Flavobacteriales;Flavobacteriaceae;Flavobacterium| |tax_ltp=Unclassified;| |tax_ltp_name=Oryza sativa Indica Group| 
	---------------------------------------------------------

	SSU
	---------------------------------------------------------
	>AAAA02045240.678.2192 |organism=Oryza sativa Indica Group| |strain= | |cut-head=0| |cut-tail=0| |alignment-quality=99| |pintail=0| |arb_name=OrySati3| |environmental-sample=| |isolation-source=| |tax_embl=Eukaryota;Viridiplantae;Streptophyta;Embryophyta;Tracheophyta;Spermatophyta;Magnoliophyta;Liliopsida;Poales;Poaceae;BEP clade;Ehrhartoideae;Oryzeae;Oryza;| |tax_embl_name=Oryza sativa Indica Group|  |tax_gg=| |tax_gg_name=| |tax_rdp=Unclassified;| |tax_rdp_name=Oryza sativa Indica Group| |tax_slv=Bacteria;Bacteroidetes;Flavobacteria;Flavobacteriales;Flavobacteriaceae;Flavobacterium| |tax_ltp=Unclassified;| |tax_ltp_name=Oryza sativa Indica Group| 


	---------------------------------------------------------

=head2 

=head1 OTHER OPTIONS

=head2 ssu|SSU

	This option is used to indicate that the input is small subunit sequences. The following sequences are removed based on uninformative taxonomy:

	REMOVE based on Silva, see CheckSilvaSSU

	$return = 0 if ( $taxonomy =~ /^Bacteria;[^;]+;?$/); #too low level, needs more details
	$return = 0 if ( $taxonomy =~ /^Bacteria;[^;]+;[^;]+;?$/); #too low level, needs more details
	$return = 0 if ( $taxonomy =~ /^Bacteria;Actinobacteria;Actinobacteria;Actinomycetales;Actinomycetaceae;?$/);
	$return = 0 if ( $taxonomy =~ /^Bacteria;Actinobacteria;Actinobacteria;uncultured;?$/);
	$return = 0 if ( $taxonomy =~ /^Bacteria;Actinobacteria;Actinobacteria;?$/);
	$return = 0 if ( $taxonomy =~ /^Bacteria;?$/);
	$return = 0 if ( $taxonomy =~ /^Archaea;?$/);
	$return = 0 if ( $taxonomy =~ /^Eukaryota;?$/);
	$return = 0 if ( $taxonomy =~ /^Eukaryota;environmental samples;?$/);
	$return = 0 if ( $taxonomy =~ /^Unclassified;?$/);

	for example:
	tax_slv=Bacteria;Proteobacteria

	REMOVE SSU GG, currently not used, check CheckGG
	REMOVE SSU RDP, currently not used, check CheckRDP 



=head2 

=head2 lsu|LSU

	This option is used to indicate that the input is large subunit sequences. The following sequences are removed based on uninformative taxonomy (at least one has to be informative):

	REMOVE based on Silva, see CheckSilva

	$return = 0 if ( $taxonomy =~ /^Bacteria;[^;]+;?$/); #too low level, needs more details
	$return = 0 if ( $taxonomy =~ /^Bacteria;Actinobacteria;Actinobacteria;Actinomycetales;Actinomycetaceae;?$/);
	$return = 0 if ( $taxonomy =~ /^Bacteria;Actinobacteria;Actinobacteria;uncultured;?$/);
	$return = 0 if ( $taxonomy =~ /^Bacteria;?$/);
	$return = 0 if ( $taxonomy =~ /^Archaea;?$/);
	$return = 0 if ( $taxonomy =~ /^Eukaryota;?$/);
	$return = 0 if ( $taxonomy =~ /^Eukaryota;environmental samples;?$/);
	$return = 0 if ( $taxonomy =~ /^Unclassified;?$/);

	for example:
	tax_slv=Bacteria;Proteobacteria

=head2 

=head1 OUTPUT

=head2 output_Silva.fasta

	The name used for output fasta file, which will have the following format:
	LSU
	---------------------------------------------------------
	>LSU_AAAA02020717.324.3101|Oryza sativa Indica Group [strain=] [embl=Oryza sativa Indica Group|Eukaryota;Viridiplantae;Streptophyta;Embryophyta;Tracheophyta;Spermatophyta;Magnoliophyta;Liliopsida;Poales;Poaceae;BEP clade;Ehrhartoideae;Oryzeae;Oryza;] [silva=Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae;Enterobacter]
	UCAAAAGAGGAAAGGCUUGCGGUGGAUACCUAGGUACCCAGAGACGAGGAAGGGCGUAGCAAGCGACGAAAUGCUUCGGGGAGUUGAAAAUAAGCAUAGAUCCGGAGAUUCCCAAAUAGGUCAACCUUUUGAACUGCCUG
	---------------------------------------------------------

	SSU
	---------------------------------------------------------
	>SSU_AAAA02020715.1.1464|Oryza|Oryza sativa Indica Group [embl=Oryza|Eukaryota;Viridiplantae;Streptophyta;Embryophyta;Tracheophyta;Spermatophyta;Magnoliophyta;Liliopsida;Poales;Poaceae;BEP clade;Ehrhartoideae;Oryzeae;Oryza;] [rdp=Unclassified|Unclassified;] [gg=Unclassified|Unclassified;]
	GCUUACACAUGCAAGUCGAGCGGUGAACCCUUCGGGGGAUCAGCGGCGAACGGGUGAGUAACACGUGAGCAACCUGCCCCUGACUCUGGGAUAGCCUCGGGAAACCGGGAUUAAUACCGGAUAUGACAUCGCCUCGCA
	---------------------------------------------------------

=head2 to screen

	---------------------------------------------------------
	acc first words differ for FirstTxons
	taxonomy1
	taxonomy2
	  ...
	id SKIPPED because Silva Taxon_Silva wanna keep?
	full_embl_taxon
	full_rdp_taxon
	full_gg_taxon
	id SKIPPED because Silva Taxon_Silva wanna keep for EMBL? Taxon_EMBL
	---------------------------------------------------------

=head1 AUTHOR

	Kasia Zaremba-Niedzwiedzka, Katarzyna.Zaremba.Niedzwiedzka@gmail.com

=cut

my $File 	= '';
my $NewFile 	= '';
my $lsu	 	= 0;
my $ssu	 	= 0;
my $Details 	= "";


# With this you can either write -i <file> OR --infile <file> OR --infile=<file>
GetOptions(
    	'i=s'  	=> \$File,
    	'o=s' 	=> \$NewFile,
	'lsu' 	=> \$lsu,
	'ssu' 	=> \$ssu,
    	'details=s' 	=> \$Details,
);

unless ( $File && $NewFile && ($lsu || $ssu) ) {
    exec( 'perldoc', $0 );    # exec exits this program automatically
}

sub CheckSilvaSSU {
	my ($taxonomy) = @_;
	my $return = 1;
	##check for unspecified taxonomy
	$return = 0 if ( $taxonomy =~ /^Bacteria;[^;]+;?$/); #too low level, needs more details
	$return = 0 if ( $taxonomy =~ /^Bacteria;[^;]+;[^;]+;?$/); #too low level, needs more details
	$return = 0 if ( $taxonomy =~ /^Bacteria;Actinobacteria;Actinobacteria;Actinomycetales;Actinomycetaceae;?$/);
	$return = 0 if ( $taxonomy =~ /^Bacteria;Actinobacteria;Actinobacteria;uncultured;?$/);
	$return = 0 if ( $taxonomy =~ /^Bacteria;Actinobacteria;Actinobacteria;?$/);
	$return = 0 if ( $taxonomy =~ /^Bacteria;?$/);
	$return = 0 if ( $taxonomy =~ /^Archaea;?$/);
	$return = 0 if ( $taxonomy =~ /^Eukaryota;?$/);
	$return = 0 if ( $taxonomy =~ /^Eukaryota;environmental samples;?$/);
	$return = 0 if ( $taxonomy =~ /^Unclassified;?$/);

	return $return
}

sub CheckSilva {
	my ($taxonomy) = @_;
	my $return = 1;
	##check for unspecified taxonomy
	$return = 0 if ( $taxonomy =~ /^Bacteria;[^;]+;?$/); #too low level, needs more details
	$return = 0 if ( $taxonomy =~ /^Bacteria;Actinobacteria;Actinobacteria;Actinomycetales;Actinomycetaceae;?$/);
	$return = 0 if ( $taxonomy =~ /^Bacteria;Actinobacteria;Actinobacteria;uncultured;?$/);
	$return = 0 if ( $taxonomy =~ /^Bacteria;?$/);
	$return = 0 if ( $taxonomy =~ /^Archaea;?$/);
	$return = 0 if ( $taxonomy =~ /^Eukaryota;?$/);
	$return = 0 if ( $taxonomy =~ /^Eukaryota;environmental samples;?$/);
	$return = 0 if ( $taxonomy =~ /^Unclassified;?$/);

	return $return
}

sub CheckEMBL {
	my ($taxonomy) = @_;
	my $return = 1;
	##check for unspecified taxonomy
	$return = 0 if ( $taxonomy =~ /^unclassified sequences/);
	$return = 0 if ( $taxonomy =~ /^other sequences/);
	$return = 0 if ( $taxonomy =~ /^Viruses/);
	$return = 0 if ( $taxonomy =~ /^Bacteria;?$/);
	$return = 0 if ( $taxonomy =~ /^Bacteria;[^;]+;?$/); #too low level, needs more details
	$return = 0 if ( $taxonomy =~ /^Bacteria;environmental samples;?$/);
	$return = 0 if ( $taxonomy =~ /^Archaea;?$/);
	$return = 0 if ( $taxonomy =~ /^Archaea;environmental samples;?$/);
	$return = 0 if ( $taxonomy =~ /^Eukaryota;?$/);

	return $return
}

sub CheckGG {
	my ($taxonomy) = @_;
	my $return = 1;
	$return = 0 if ( $taxonomy eq "" );
	##check for unspecified taxonomy
	$return = 0 unless ( $taxonomy =~ /p__/); #classified at phylum level
	$return = 0 if ( $taxonomy =~ /Bacteria/  && !($taxonomy =~ /c__/) ); #bacteria not classified to class level
	$return = 0 if ( $taxonomy =~ /^Unclassified;?$/);	#should already be excluded by lack of phylum 'p__'

	return $return
}

sub CheckRDP {
	my ($taxonomy) = @_;
	my $return = 1;
	$return = 0 if ( $taxonomy eq "" );
	##check for unspecified taxonomy
	$return = 0 if ( $taxonomy =~ /^Bacteria;[^;]+$/);
	$return = 0 if ( $taxonomy =~ /^Bacteria;?$/);
	$return = 0 if ( $taxonomy =~ /^Unclassified;?$/);
	return $return
}

sub EditGG {
	my ($taxonomy) = @_;
	my $return = $taxonomy;
	#remove level information
	$return =~ s/\w__//g; 
	$return =~ s/ \(class\)//g; 
	$return =~ s/Unclassified;?$//g; 
	return $return
}

sub EditRDP {
	my ($taxonomy) = @_;
	my $return = $taxonomy;
	#remove level information
	$return =~ s/"//g;

	return $return
}

sub AgreedBasics {
	my ($gdzie_details,$acc,@TaxonsDatabase) = @_;
	my @FirstTaxons; # my @SecondTaxons;
	#report if the first two level disagree
	#first two levels too much, all vertebrates removed:	#tax_embl=Eukaryota;Metazoa;Chordata;Craniata;Vertebrata;Euteleostomi;Mammalia;Eutheria;Laurasiatheria;Cetartiodactyla;Suina;Suidae;Sus;
	#tax_slv=Eukaryota;Opisthokonta;Metazoa;Craniata;Craniata;Mammalia
	foreach my $tax_list (@TaxonsDatabase) {
		my @tax_array = split(/;/,$tax_list);
		#highest classified taxa
		my $t_first = shift @tax_array;
		### my $t_second = shift @tax_array;
		push(@FirstTaxons,$t_first);
		### push(@SecondTaxons,$t_second);
		#print $gdzie_details "$t_second @tax_array";
	}
	### IF at least two of them agree, then uniq list should be shorter then full one
	my @FirstTaxons_uniq = uniq @FirstTaxons;
	if ( $#FirstTaxons_uniq < $#FirstTaxons ) {
		#my @SecondTaxons_uniq = uniq @SecondTaxons;	
		#if ( $#SecondTaxons_uniq < $#SecondTaxons ) {
			# simple check is OK
		return 1;
		#}
		#else {	
		#	print $gdzie_details "Second words differ @SecondTaxons\n";
		#	foreach my $t (@TaxonsDatabase) { print $gdzie_details " $t\n"; }
		#	return 0;
		#}
	}
	else {	
		print $gdzie_details "$acc first words differ for @FirstTaxons\n";
		foreach my $t (@TaxonsDatabase) { print $gdzie_details " $t\n"; }
		return 0;
	}
}

my $fasta_in = Bio::SeqIO->new(-file => "$File",
				-format => 'fasta');

my $all = 0; my $out_taxonomy = 0; my $out_basics = 0;
open my $OUT, '>', $NewFile 	or die "could not open $NewFile to write";
open my $DETAILS, '>', $Details or die "could not open $Details to write";
DATABASE:while ( my $seq = $fasta_in->next_seq() ) {
	my $accession = $seq->display_id;
	$all += 1;
	my $desc_new;
	my ($strain) = $seq->desc =~ m{\|strain=([^\|]+)\|};
	$strain = "" if ( $strain eq " " );
	$strain =~ s/\(t\)/ typestrain/g; 
	$strain =~ s/\[T\]/ typestrain/g; 	
	$strain =~ s/\[C\]/ cultivated/g; 
	$strain =~ s/\[G\]/ genome/g; 

	if ( $ssu ) {
		#ltp skipped
		if ( $seq->desc =~ /\|organism=([^\|]+)\|.+\|tax_embl=([^\|]+)\| \|tax_embl_name=([^\|]+)\| +\|tax_gg=([^\|]*)\| \|tax_gg_name=([^\|]*)\| \|tax_rdp=([^\|]+)\| \|tax_rdp_name=([^\|]*)\| \|tax_slv=([^\|]+)\| / ) {
			my $species = $1; my $Taxon_EMBL = $2; my $Taxon_EMBL_name = $3;
			my $Taxon_GG = $4; my $Taxon_GG_name = $5; 
			my $Taxon_RDP = $6; my $Taxon_RDP_name = $7;
			my $Taxon_Silva = $8; 

			my $Taxon_RDP_edited = EditRDP($Taxon_RDP);
			my $Taxon_GG_edited = EditGG($Taxon_GG);

			my $full_embl_taxon	="$Taxon_EMBL;$Taxon_EMBL_name";
			my $full_gg_taxon	="$Taxon_GG_edited;$Taxon_GG_name";
			my $full_rdp_taxon	="$Taxon_RDP_edited;$Taxon_RDP_name";

			if ( CheckSilvaSSU($Taxon_Silva)  ) {
				$desc_new = "SSU_$accession|$species [strain=$strain] [embl=$full_embl_taxon] [rdp=$full_rdp_taxon] [gg=$full_gg_taxon] [silva=$Taxon_Silva]";
				my @Taxons = ();
				push(@Taxons,$Taxon_Silva);
				push(@Taxons,$full_embl_taxon) 	if (CheckEMBL($full_embl_taxon)); 
				push(@Taxons,$full_gg_taxon) 	if (CheckGG($full_gg_taxon)); 
				push(@Taxons,$full_rdp_taxon) 	if (CheckRDP($full_rdp_taxon)); 
				my $simple_check = AgreedBasics($DETAILS,$accession,@Taxons);
				if ( $simple_check ) {
					#at least first two in agreement
				}
				else {
					$out_basics += 1;
					next DATABASE;
				}
			}
			else {
				print $seq->display_id, " SKIPPED because Silva $Taxon_Silva \twanna keep?\n $full_embl_taxon\n $full_rdp_taxon\n $full_gg_taxon\n";
				#uninformative are skipped!
				$out_taxonomy += 1;
				next DATABASE;
			}
		}
		else {
		      print "ERROR ", $seq->display_id, " this sequence unrecognized format of description. Check: ", $seq->desc ,"\n";
		      #next DATABASE;
		}
	}
	elsif ( $lsu ) {
		#ltp skipped
		if ( $seq->desc =~ /\|organism=([^\|]+)\|.+\|tax_embl=([^\|]+)\| \|tax_embl_name=([^\|]+)\| .+ \|tax_slv=([^\|]+)\|/ ) {
			my $species = $1; my $Taxon_EMBL = $2; my $Taxon_EMBL_name = $3; my $Taxon_Silva = $4; 
			if ( CheckSilva($Taxon_Silva)  ) {
				my $full_embl_taxon="$Taxon_EMBL;$Taxon_EMBL_name";
				$desc_new = "LSU_$accession|$species [strain=$strain] [embl=$full_embl_taxon] [silva=$Taxon_Silva]";
				my @Taxons = ();
				push(@Taxons,$Taxon_Silva);
				push(@Taxons,$full_embl_taxon);
				my $simple_check = AgreedBasics($DETAILS,$accession,@Taxons);
				if ( $simple_check ) {
					#at least first two in agreement
				}
				else {
					$out_basics += 1;
					next DATABASE;
				}
			}
			else {
				print $seq->display_id, " SKIPPED because Silva $Taxon_Silva \twanna keep for EMBL? \t$Taxon_EMBL\n";
				#uninformative are skipped!
				$out_taxonomy += 1;
				next DATABASE;
			}
		}
		else {
		      print "ERROR ", $seq->display_id, " this sequence unrecognized format of description. Check: ", $seq->desc ,"\n";
		      #next DATABASE;
		}
	}
	print $OUT ">$desc_new\n";
	die "what is wrong with this sequence $accession", $seq->desc, "\n" unless ($desc_new =~ /SU_/);
	print $OUT $seq->seq,"\n";
}

print "Out of $all sequences:\n $out_taxonomy sequences with no taxonomic information taken out.\n $out_basics sequences with disagreing EMBL and Silva first two taxons were taken out, details in $Details.\n";
print "Out of $all sequences:\n $out_taxonomy sequences with no taxonomic information taken out.\n $out_basics sequences with disagreing EMBL and Silva first two taxons were taken out, details in $Details.\n";

close($OUT);
close($DETAILS);