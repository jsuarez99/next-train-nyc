#!/usr/bin/perl

use strict;

my $stop = 'R42N'; #nbound bay ridge ave stop
#my $stop = 'R24S'; #sbound city hall R stop
#my $stop = 'Q01S'; #sbound Canal N stop
chomp(my $curdow = `date '+%u'`);  #get day of week (1-7, 1 is monday)
chomp(my $curtime = `date '+%H:%M'`);
my @results = ();
my $sched;

if($curdow < 6){
    chomp(my $dowName = `date '+%A'`);
    print "It is $dowName, the current time is $curtime.\n";
    $sched = "WKD";
}
elsif($curdow == 6){
    print "It is Saturday, the current time is $curtime.\n";
    $sched = "SAT";
}
elsif($curdow == 7){
    print "It is Sunday, the current time is $curtime.\n";
    $sched = "SUN";
}


chomp(@results = `cat google_transit/stop_times.txt | grep '$stop' | grep '$sched' | sort | cut -d, -f2`);

my ($h, $m) = split(':',$curtime);

for(my $i = 0; $i < @results; $i++){
    my ($schedHour, $schedMin, $schedSec) = split(':',$results[$i]);
	
    if($h . $m > $schedHour . $schedMin){
		#print "$h$m > $schedHour$schedMin\n";
		next;
    }
    
    print "The next train is arriving at $results[$i]. The train after will arrive at " . $results[$i+1] . ".\n";
    last;    
}
