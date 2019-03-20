# Identifying positioned nucleosomes in yeast

This is a script used to assign the role of genomic nucleosomes as specific positions for 
genes; in other words, the -2, -1, +1, +2, +3, +4, and terminal nucleosomes. In many 
cases, nucleosomes could be assigned to multiple roles. Yeast have very small intergenic 
regions, so that a -1 nucleosome is quite frequently the +1 or terminal nucleosome of an 
upstream gene. This script picks a single role for each nucleosome, emphasizing the plus 
positions and terminal nucleosomes over minus positions, and assigning the role with the 
greatest overlap with a role position. See the unfiltered nucleosome file for all 
assignments; there will be duplicate assignments in this file. 

### Requirements

1. a GFF3 file of the mapped nucleosomes

	You can generate this with the `map_nucleosomes.pl` script included with this 
	package. It assumes that the GFF `type` is "nucleosome" and that the `source` 
	value is set to something, e.g. "WT".
	
	To generate a GFF file from a text file, run `data2gff.pl`, as shown below as an
	example. Note that we are setting the GFF `type` as "nucleosome", while the GFF
	`source` is used to differentiate multiple sources. 
	
		$ data2gff.pl --in WT_nucleosomes.verified.txt \
		--id 4 --name 4 --score 5 \
		--source WT --type nucleosome \
		--out WT_nucleosomes.gff3

1. a GFF3 file of yeast annotation

	One is included here. This file includes UTRs mapped by yours truly from high
	resolution microarray expression data. It's mostly accurate. The UTRs are
	important as it defines the transcription start and stop site, which are missing
	from the official SGD annotation. 

### Build database

With these two files, load a BioPerl `Bio::DB::SeqFeature::Store` database into a SQLite 
database file using the BioPerl script.

	$ bp_seqfeature_load.pl -c -N -f -a DBI::SQLite -d SacCer3_nuc.db \
	SacCer3_R64_all_genes_NoDubious_UTR_chromo.gff3 WT_nucleosomes.gff3 

### Run script

Then run the script, passing two arguments: the name of the database and the nucleosome 
feature `source`. This is needed to find the nucleosome feature in the database.

	$ ./get_positioned_nucs.sh SacCer3_nuc.db WT

You should get out numerous files, including bed files for each positioned nucleosome.

The postions are hard-coded, but were empirically tested and included the following 
ranges.

- -2 nucleosome centered within -400..-275

- -1 nucleosome centered withing -250..-125

- +1 nucleosome centered within 0..125

- +2 nucleosome centered within 150..275

- +3 nucleosome centered within 300..450

- +4 nucleosome centered within 475..600

- term1 nucleosome centered within -100..25 relative to transcript 3' position

### Output

For each positioned nucleosome role, a text file and bed file is generated. The text 
file has more information, while the bed file is useful for verifying in a genome browser.

There are also two bulk text files with all of the identified nucleosomes compiled.
The first is a compilation of all the individual positioned text files, but with a
little more information. The second is an unfiltered list, and contains all the
nucleosomal roles prior to prioritization and filtering; there are duplicates in
here, but it illustrates the multiple roles a nucleosome might be in.

