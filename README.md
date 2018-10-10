# NAME

Bio-ToolBox-Nucleosome - Scripts for working with nucleosome sequences

# DESCRIPTION

This is a collections of specialized scripts written for working with 
next-generation sequencing of MNase-digested mononucleosome DNA (MNase-Seq).
At the time these were written many years ago (late 00s), there was little else 
written for identifying, mapping, and working with nucleosomal reads. There are 
a now a few other projects that do so. This package may not be the most accurate, 
but they work in a relatively simple manner, at least for cerevisiae. 

These were initially part of the [Bio::ToolBox](https://github.com/tjparnell/biotoolbox) 
package, at least in early versions (earlier than 1.30). For a while, they were 
part of the legacy [Bio::ToolBox::Extra](https://github.com/tjparnell/biotoolbox-extra) 
package, but have now moved out into it's own.

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




