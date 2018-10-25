#!/bin/sh

# script to identify named, positioned nucleosomes relative to transcripts


# Input database of transcripts and all nucleosomes
# prepare a SQLite database loaded with modified UTR gene GFF3 with the WT nucleosomes
# bp_seqfeature_load.pl -c -f -a DBI::SQLite \
# -d SacCer3_nuc.db \
# SacCer3_R64_all_genes_NoDubious_UTR_chromo.gff3 
# nucleosome.gff3 

# pass the name of the database file and source name of nucleosome data to this script
DATABASE=$1
NAME=$2

if [ -e $DATABASE ]
then
	echo "##### Positioned nucleosome generator #######"
	echo "using database $DATABASE"
else
	echo " Please provide the name of a Bio::DB::SeqFeature::Store database containing"
	echo " both transcripts and all mapped nucleosomes loaded into it. See documentation."
	echo " Also provide a source name to the nucleosome"
	echo " $0 {SacCer3_nuc.db} {name}"
	echo 
	exit
fi


##### Generate the list of transcripts
echo "####### Collecting Transcripts"

# I need a list of transcripts that includes the strand of each 
# transcript for collecting strand-oriented nucleosomes

# two transcript files:
# 	transcript_list.txt has all transcripts
#	transcript_list_prom500.txt has transcripts with no intersecting transcripts 500 bp upstream

# collect all transcripts
echo
echo "# All transcripts"
get_features.pl --db $DATABASE --feature mRNA --out transcript_list.txt

# collect the 500bp promoter free transcripts
echo
echo "# Finding and trimming intersecting upstream genes and transcripts"
get_datasets.pl --in transcript_list.txt --data 'mRNA&ncRNA&tRNA&snRNA' --method count --start=-500 --stop=-1 --out transcript_list_prom500.txt

manipulate_datasets.pl --func above --target 0 --index 3 --in transcript_list_prom500.txt

manipulate_datasets.pl --func delete --index 3 --in transcript_list_prom500.txt

# collect strand
for name in transcript_list.txt transcript_list_prom500.txt
do
	get_feature_info.pl --in $name --attrib strand
done




### Collect the positioned nucleosomes
echo
echo
echo
echo "####### Collecting TSS positioned nucleosome ########"
# plus 1 nucleosome
echo "# collecting plus1 nuc"
get_intersecting_features.pl --feature nucleosome:$NAME --in transcript_list.txt --start=0 --stop 125 --ref start --out ${NAME}_nuc_plus1

# plus 2 nucleosome
echo "# collecting plus2 nuc"
get_intersecting_features.pl --feature nucleosome:$NAME --in transcript_list.txt --start 150 --stop 275 --ref start --out ${NAME}_nuc_plus2

# plus 3 nucleosome
echo "# collecting plus3 nuc"
get_intersecting_features.pl --feature nucleosome:$NAME --in transcript_list.txt --start 300 --stop 450 --ref start --out ${NAME}_nuc_plus3

# plus 4 nucleosome
echo "# collecting plus4 nuc"
get_intersecting_features.pl --feature nucleosome:$NAME --in transcript_list.txt --start 475 --stop 600 --ref start --out ${NAME}_nuc_plus4

# minus 1 nucleosome all genes
echo "# collecting all minus1 nuc"
get_intersecting_features.pl --feature nucleosome:$NAME --in transcript_list.txt --start=-250 --stop=-125 --ref start --out ${NAME}_nuc_minus1

# minus 2 nucleosome -500 free genes
echo "# collecting prom500 minus2 nuc"
get_intersecting_features.pl --feature nucleosome:$NAME --in transcript_list_prom500.txt --start=-400 --stop=-275 --ref start --out ${NAME}_nuc_minus2



# each file should now have 
#	Primary_ID	Name	Type	strand	Number	Name	Type	Strand	Distance Overlap
#	First four columns are transcript specific, remainder nucleosome specific

# process each of the resulting files
echo
echo
echo "#### processing the positioned intersected nucleosome"
for nuc in nuc_plus1 nuc_plus2 nuc_plus3 nuc_plus4 nuc_minus1 nuc_minus2 
do
	echo
	echo "## processing $name"
	
	
	# drop anything that doesn't intersect with a nucleosome
	# even when two nucs intersect, the one with most overlap is reported
	echo "# removing non-intersecting genes"
	manipulate_datasets.pl --func below --index 4 --target 1 --in ${NAME}_${nuc}
	
	echo "# applying common value $name"
	manipulate_datasets.pl --func new --target $nuc --name Location --in ${NAME}_${nuc}
	
	# reorder columns, I want to keep
	#	Name (nucleosome) 5
	#	Type (nucleosome) 6
	#   Location 10
	#	Name (transcript) 1
	#	Strand (transcript) 3
	#	Distance 8
	#   Overlap 9
	echo "# reordering columns"
	manipulate_datasets.pl --func reorder --index 5,6,10,1,3,8,9 --in ${NAME}_${nuc}
	
	# Rename columns
	echo "# renaming columns"
	manipulate_datasets.pl --func rename  --index 0,1,3 --name Name,Type,Transcript_Name --in ${NAME}_${nuc}
	
	# collect attributes
	echo "# collecting attributes"
	get_feature_info.pl --in ${NAME}_${nuc} --attrib chromo,start,stop,score
	# files should now have :
	# Name, Type, Location, Transcript_Name, strand, Distance, Overlap, Chromo, Start, Stop, Score
	
done

# merge the files into one file
echo "# joining nucleosome files"
join_data_file.pl --out ${NAME}_nucs.txt ${NAME}_nuc_plus1 ${NAME}_nuc_plus2 ${NAME}_nuc_plus3 ${NAME}_nuc_plus4 ${NAME}_nuc_minus1 ${NAME}_nuc_minus2 

# cleaning up and making backup
rm ${NAME}_nuc_plus1.txt ${NAME}_nuc_plus2.txt ${NAME}_nuc_plus3.txt ${NAME}_nuc_plus4.txt ${NAME}_nuc_minus1.txt ${NAME}_nuc_minus2.txt
cp ${NAME}_nucs.txt ${NAME}_nucs_unfiltered.txt

# delete the duplicate nucleosomes
# first need to perform some sorting
echo "# sorting nucleosome files"
# first overlap
manipulate_datasets.pl --func sort --index 6 --dir d --in ${NAME}_nucs.txt
# second name
manipulate_datasets.pl --func sort --index 0 --dir i --in ${NAME}_nucs.txt
echo "# removing duplicate nucleosomes"
manipulate_datasets.pl --func duplicate --index 0 --in ${NAME}_nucs.txt
# re-sort by genomic coordinate
manipulate_datasets.pl --func gsort --in ${NAME}_nucs.txt

# split the file 
echo "# splitting nucleosome file"
split_data_file.pl --index 2 ${NAME}_nucs.txt

for nuc in nuc_plus1 nuc_plus2 nuc_plus3 nuc_plus4 nuc_minus1 nuc_minus2
do
	echo "# cleaning up file $name"
	# change the name
	mv ${NAME}_nucs\#${nuc}.txt ${NAME}_${nuc}.txt
	
	# delete the unnecessary columns
	manipulate_datasets.pl --func reorder --index 0,1,3,4,7-10 --in ${NAME}_${nuc}.txt
	# files now will have 
	# Name, Type, Transcript_Name, Transcript_Strand, Chromo, Start, Stop, Score
	
	# reformat score
	manipulate_datasets.pl --func format --target 2 --place r --index 7 --in ${NAME}_${nuc}.txt
	
	# export as bed
	data2bed.pl --in ${NAME}_${nuc}.txt --strand 3 --score 7 
	
done


