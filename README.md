# NAME

Bio-ToolBox-Nucleosome - Scripts for working with nucleosome sequences

# DESCRIPTION

This is a collections of specialized scripts written for working with 
next-generation sequencing of MNase-digested mononucleosome DNA (MNase-Seq).
At the time these were written many years ago (late 00s), there was little else 
written for identifying, mapping, and working with nucleosomal reads. There are 
now a few other projects that do so. This package may not be the most accurate, 
but it works reasonably well, at least for _S. cerevisiae_. 

These were initially part of the [Bio::ToolBox](https://github.com/tjparnell/biotoolbox) 
package, at least in early versions (earlier than 1.30). For a while, they were 
part of the legacy [Bio::ToolBox::Extra](https://github.com/tjparnell/biotoolbox-legacy) 
package, but have now moved out on its own.

# USAGE

These scripts were written primarily for _S. cerevisiae_ nucleosomes. They may or may 
not work with other model system. Since yeast have very well-ordered nucleosomes, it's 
relatively easy to map them. This package has primarily four scripts.

- `map_nucleosomes.pl`

    This is the main script to map nucleosome positions. It maps based on the position 
    of the peak of nucleosome fragment midpoints within an incrementally sliding window. 
    Search windows are based relavent to the previously identified nucleosome, in 
    accordance to nucleosome stacking laws. If you can pick out nucleosome positions 
    just by eye from nucleosomal fragment midpoint data in a genome browser without fancy 
    smoothing or hidden Markov model states, then this program will work. This, of 
    course, presumes a good degree of duplicate fragment positions (stack of identical 
    nucleosomes) which is common with MNaseSeq data, but PCR-duplication is a concern. 
    You may wish to threshold duplicate percentages between replicates and/or conditions 
    using `bam_partial_dedup` from the 
    [MultiRepMacsChIPSeq](https://github.com/HuntsmanCancerInstitute/MultiRepMacsChIPSeq) 
    package. 
    
    Generate bigWig files of nucleosome midpoint data using, for example, 
    [bam2wig.pl](https://metacpan.org/pod/bam2wig.pl). Either single- or paired-end 
    alignments could and have been used successfully. 
    
    UPDATE: Actually, working with "skinny" nucleosome coverage appears to give the 
    best results. Generate nucleosome coverage over the central 50% (or less) portion 
    of the nucleosome. With single-end alignments and `bam2wig.pl`, use 
    `--shift 37 --extend 75` to generate "skinny" nucleosomes. This "accentuates" the 
    nucleosome occupancy curves while averaging out the density of nucleosome midpoints. 
    There are much fewer "off-center" nucleosomes, fewer overlaps, and fewer "weak" 
    nucleosomes called (because you can increase stringency) with this technique.

- `verify_nucleosome_mapping.pl`

    This is an optional script, but will verify how well the nucleosomes were mapped 
    with the script above, and optionally re-adjust and/or discard nucleosomes. 
    Probably a good idea to do so.

- `get_actual_nuc_sizes.pl`

    A script to take the mapped nucleosomes, grab the actual paired-end alignments from 
    the original Bam file, and try to calculate the actual nucleosome size. YMMV

- `intersect_nucs.pl`

    A script to take two list files of mapped nucleosomes, and intersect them, 
    identifying which nucleosomes overlap and calculating some rudimentary statistics. 
    May be marginally useful....

- `correlate_position_data.pl`

    This script is not part of this package but rather part of the 
    [Bio::ToolBox](https://github.com/tjparnell/biotoolbox) package and is particularly 
    useful here when working with nucleosomal data between different conditions. It will 
    identify differences in the spatial position of signal over defined intervals, such 
    as mapped nucleosomes. Differences between two datasets can be reported with a p-value, 
    and importantly, an optimal shift in the signal. In other words, if the nucleosome 
    signal in a mutant condition has shifted relavent to wildtype, this program will 
    identify it, with caveats to the original mapping, nucleosome fuzziness, etc. 

## Identifying positioned nucleosomes in yeast

The subfolder `yeast_positioned_nucleosomes` contains a bash script for using a number 
of BioToolBox programs for identifying positioned nucleosomes, i.e. the plus1, plus2, 
plus3, etc nucleosomes over each transcript. It may be useful to you, either as is or 
with modifications.

# REQUIREMENTS

These are Perl modules and scripts. They require Perl and a unix-like 
command-line environment. They have been developed and tested on Mac 
OS X and linux; Microsoft Windows compatability is not tested nor 
guaranteed.

These scripts require the installation of [Bio::ToolBox](https://github.com/tjparnell/biotoolbox), 
and all the requirements therein, especially notably a Bam and bigWig file 
adapters. There are advanced installation instructions on the BioToolBox page.

This will also require the [Bio::ToolBox::Legacy](https://github.com/tjparnell/biotoolbox-legacy) 
module as well. 

# INSTALLATION

Installation is simple with the standard Perl incantation.

    perl ./Build.PL
    ./Build installdeps     # if necessary
    ./Build
    ./Build install


# AUTHOR

	Timothy J. Parnell, PhD
	Huntsman Cancer Institute
	University of Utah
	Salt Lake City, UT, 84112

# LICENSE

This package is free software; you can redistribute it and/or modify
it under the terms of the Artistic License 2.0. For details, see the
full text of the license in the file LICENSE.

This package is distributed in the hope that it will be useful, but it
is provided "as is" and without any express or implied warranties. For
details, see the full text of the license in the file LICENSE.




