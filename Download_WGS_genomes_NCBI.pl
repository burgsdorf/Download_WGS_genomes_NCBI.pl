## Created/modified by I Burgsdorf Feb 2020.
## Internet connection is required!
## Input file is your table contains genome accessions
## VXLI00000000  ---> VXLI01 ---> VX/LI/VXLI01/VXLI01.1.fsa_nt.gz
## Usage: perl -w Download_WGS_genomes_NCBI.pl YOUR_TABLE_WITH_accessions.txt
## Run from LINUX only!
#===========================
use strict;
use warnings;
#=============================================================================================================================================================

#----------------IN/OUT-----------------------------------------------
my ($in_table) = @ARGV; 
open (my $in, "<", $in_table) or die "cannot open $in_table";     # IN

# Create automatic output file based on the fasta file name
my $outTABLE = "$ARGV[0].short.accessions.txt";                                                
open(my $out, ">", $outTABLE) or die "cannot open $outTABLE";  # OUT
print $out "Short accession\tDownloaded file\n";
#-----------------------------------------------------------------

# Loading array form a file
my @table = <$in>;
chomp @table;
my $tabel_size = @table;
print $out "$tabel_size loaded.\nConnecting to server.";

my $short_accession;
my $tempfile;
my $counter=0;

print "A. Are you providing WGS accession numbers (e.g. VXLI01)\nor\nB. NCBI accession numbers (e.g. VXLI00000000)?\n";
my $variant = <STDIN>;
 
if ($variant eq "A\n") {
	foreach my $line (@table) {	             # Load accesion number (e.g. VXLI01) 
		my $letters1 = substr($line, 0, 2);			    # VX
		my $letters2 = substr($line, 2, 2);             # LI
		my $short_accession = $line;
		my $file = $short_accession . ".1.fsa_nt.gz";
		print $out "$short_accession\t$file\n";   
		$counter++;	
		my $cmd = "wget https://sra-download.ncbi.nlm.nih.gov/traces/wgs01/wgs_aux/$letters1/$letters2/$short_accession/$file";
		system($cmd);
	}
}
elsif ($variant eq "B\n") {                                                                                            
	foreach my $line (@table) {	             # Load accesion number (e.g. VXLI00000000) 
		my $letters1 = substr($line, 0, 2);			    # VX
		my $letters2 = substr($line, 2, 2);             # LI
		my $short_accession = substr($line, 0, 5);
		$short_accession = $short_accession . "1";
		my $file = $short_accession . ".1.fsa_nt.gz";
		print $out "$short_accession\t$file\n";  
		$counter++;		
		my $cmd = "wget https://sra-download.ncbi.nlm.nih.gov/traces/wgs01/wgs_aux/$letters1/$letters2/$short_accession/$file";
		system($cmd);
	}
}
else {  
	print "Please write A or B next time. Thanks!\n";
}

if ($tabel_size != $counter) {
	print "\n\n\n\n\n\n=================================================================\nWe have a liitle problem. wget command called $counter times for $tabel_size accessions numbers.\n=================================================================\n";  	
	print "We counted this number of *.fsa_nt.gz files in this folder:\n";
	my $cmd = "ls *.fsa_nt.gz | wc -l";
	system($cmd);
}

print "\n\n\n\n\n\n=================================================================\nEverything looks good. wget command called $counter times for $tabel_size accessions numbers.\n=================================================================\n";
print "We counted this number of *.fsa_nt.gz files in this folder:\n";
my $cmd = "ls *.fsa_nt.gz | wc -l";
system($cmd);

close($in);
close($out);
