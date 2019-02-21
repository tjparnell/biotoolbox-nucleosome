# Identifying positioned nucleosomes in yeast

This is a script used to identify the positioned nucleosomes around the 5' ends of 
genes; in other words, the -2, -1, +1, +2, and +3 nucleosomes. 

Requirements include 

1. a GFF3 file of the mapped nucleosomes

	You can generate this with the `map_nucleosomes.pl` script included with this 
	package. It assumes that the GFF `type` is "nucleosome" and that the `source` 
	value is set to something, e.g. "WT".

1. a GFF3 file of yeast annotation

	One is included here. This file includes UTRs mapped by yours truly from 
	high resolution microarray expression data. It's mostly accurate.

With these two files, load a BioPerl Bio::DB::SeqFeature::Store database into a SQLite 
database file using the BioPerl script.

	$ bp_seqfeature_load.pl -c -f -a DBI::SQLite -d SacCer3_nuc.db \
	SacCer3_R64_all_genes_NoDubious_UTR_chromo.gff3 nucleosome.gff3 

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

