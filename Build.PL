#!/usr/bin/perl

use strict;
use warnings;
use Module::Build;



# Build the script
my $build = Module::Build->new(
	dist_name         => 'Bio-ToolBox-Nucleosome',
	module_name       => 'Bio-ToolBox-Nucleosome',
	dist_version      => 1,
	dist_abstract     => 'Scripts for working with nucleosome sequences',
	dist_author       => 'Timothy Parnell <timothy.parnell@hci.utah.edu>',
	license           => 'artistic_2',
	meta_merge        => {
		resources     => {
			repository     => 'https://github.com/tjparnell/Bio-ToolBox-nucleosome'
		}
	},
	configure_requires => {
		'Module::Build'           => 0,
	},
	requires          => {
		'Bio::Root::Version'            => 1.007002,
		'Bio::DB::SeqFeature::Store'    => 0,
		'Bio::DB::HTS'                  => 3.01,
		'Bio::DB::Big'                  => 1.0,
		'Bio::ToolBox'                  => >= 1.66, < 1.70,
		'Bio::ToolBox::Legacy'          => 1.62
	},
	recommends        => {
	},
);

$build->create_build_script;
exit 0;


