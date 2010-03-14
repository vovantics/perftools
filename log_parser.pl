#!/usr/bin/perl
use strict;
use warnings;

# Log Parser
# Stevo
# Version 1.0
# 2010-02-27

# The Log Parser reads an input stream of text from a log file and outputs every
# line as a set of CSVs if the line matches the following format:
#
# 2010-02-27 18:03:56,033  INFO - start[1267311835950] time[82] tag[TESTING] message[unit-date_format-date]
#
# The output should look something like this:
# date, time, start, duration, tag, message
# 2010-02-27, 18:35:42, 1267313742396, 2, updateXMPCreateDate, unit-date_format-date
# 2010-02-27, 18:35:42, 1267313742379, 19, updateRDFDateTimeStamps, unit-date_format-date
# 2010-02-27, 18:35:47, 1267313747650, 155, getMetadata, integration-retrieve_metadata-camera

#print("date, time, start, duration, tag, message\n");
while (my $line = <>)
{
	if ($line =~ m/(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2}),\d{3}  INFO - start\[([\d]+)\] time\[([\d]+)\] tag\[(.+)\] message\[(.+)\]/)
	{
		#print("date=[$1] time=[$2] start=[$3] duration=[$4] tag=[$5] message=[$6]\n");
		print("$1, $2, $3, $4, $5, $6\n");
	}
}
