#!/usr/bin/perl
use strict;
use warnings;

# Performance Stat Cruncher
# Stevo
# Version 1.0
# 2010-03-12

# The Performance Stat Cruncher reads an input stream of text from a log file and outputs every
# line as a set of CSVs if the line matches the following format:
#
# date, time, start, duration, tag, message
# 2010-02-27, 18:35:42, 1267313742396, 2, updateXMPCreateDate, unit-date_format-date
# 2010-02-27, 18:35:42, 1267313742379, 19, updateRDFDateTimeStamps, unit-date_format-date
# 2010-02-27, 18:35:47, 1267313747650, 155, getMetadata, integration-retrieve_metadata-camera
#
# The output should look something like this:
# tag, mean, standard deviation
# synchronizeRDF, 1, 1
# clearRDF, 2.5, 3.70135110466435
# getMetadata, 12.123595505618, 5.12617810771974

my %data_map;
my %sum_map;
my %count_map;
my %mean_map;
my %sd_map;


while (my $line = <>)
{
	my ($date,$time,$start,$duration,$tag,$message) = split ',', $line;
  	
	if (!defined($sum_map{$tag}))
	{
		$sum_map{$tag} = $duration;
		$count_map{$tag} = 1;
		my @data = ($duration);
		$data_map{$tag} = \@data;
	}
	else {

		$sum_map{$tag} += $duration;
		$count_map{$tag}++;
		my $data_ref = $data_map{$tag};
		my @data = @$data_ref;
		push(@data, $duration);
		$data_map{$tag} = \@data;
	}
}

# Calc mean
while (my ($tag, $sum) = each %sum_map)
{
	my $mean = $sum / $count_map{$tag};
	$mean_map{$tag} = $mean;
}

# Calc standard deviation
while (my ($tag, $data_ref) = each %data_map)
{
	my $sq_total = 0;
	my @data = @$data_ref;
	foreach my $duration (@data)
	{
		$sq_total += ($duration - $mean_map{$tag}) ** 2;
	}
	my $std = ($sq_total / $sum_map{$tag}) ** 0.5;
	my $count = scalar(@data);
	print("$tag, $mean_map{$tag}, $std, $count\n");
}
