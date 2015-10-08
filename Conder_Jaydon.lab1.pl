######################################### 	
#    CSCI 305 - Programming Lab #1		
#										
#  < Jaydon Conder and Will Dittman >			
#  <williamdittman3@gmail.com and Jaydonrconder@gmail.com >			
#										
#########################################

# Replace the string value of the following variable with your names.
my $name = "Jaydon Conder";
my $partner = "William Dittman";
print "CSCI 305 Lab 1 submitted by $name and $partner.\n\n";

# Checks for the argument, fail if none given
$ARGV[0] = "unique_tracks.txt";

if($#ARGV != 0) {
    print STDERR "You must specify the file name as the argument.\n";
    exit 4;
}

print "Please wait while the file is parsed.\n";
# Opens the file and assign it to handle INFILE
open(INFILE, $ARGV[0]) or die "Cannot open $ARGV[0]: $!.\n";


# YOUR VARIABLE DEFINITIONS HERE...
my $songs;
my $songsplit ="";
my $title;
my $mostcommon;
my %bigram;

# This loops through each line of the file
my $i;
my %frequency_bigrams;

while($line = <INFILE>) {
    
    if($line =~ m/<SEP>(.*)/){
        $song = $1;
    
        if($song =~ m/<SEP>(.*)/){
            $song = $1;
            
            if($song =~ m/<SEP>(.*)/){
                #reads through each line and removes everything up to the song title, and then removes extraneous
                #bits of information, such as artists being featured in the songs, various punctuation, and makes
                #all of the remaining words lower case, in order to keep them consistent. 
                $song = $1; 
                $song =~ s/\[(.*)//;
                $song =~ s/\((.*)//;
                $song =~ s/\"(.*)//;
                $song =~ s/feat.(.*)//;
                $song =~ s/\{(.*)//;
                $song =~ s/\/(.*)//;
                $song =~ s/\\(.*)//;
                $song =~ s/\_(.*)//;
                $song =~ s/\-(.*)//;
                $song =~ s/\:(.*)//;
                $song =~ s/\`(.*)//;
                $song =~ s/\+(.*)//;
                $song =~ s/\=(.*)//;
                $song =~ s/\*(.*)//;
                $song =~ s/[[:punct:]]//g;
                $song = lc($song);
                
                 #Removes various stop words to stop the created song titles to help keep the titles from repeating too often.
                $song =~ s/an //g;
                $song =~ s/a //g;
                $song =~ s/and //g;
                $song =~ s/by //g;
                $song =~ s/for //g;
                $song =~ s/from //g;
                $song =~ s/in //g;
                $song =~ s/of //g;
                $song =~ s/on //g;
                $song =~ s/or //g;
                $song =~ s/out //g;
                $song =~ s/the //g;
                $song =~ s/to //g;
                $song =~ s/with //g;
                
                #checks to make sure the song doesn't have any non-english characters or 
                #that it is not just an empty line after deleting 
                if ($song =~ m/[^a-z ]/ | $song =~ /^$/) {
                }
                else {    
                    #creates an array that contains the different substrings in the song title
                    #every substring is one of the words in the song title
                   @words = split(/ /, $song);
                   #iterates through the array, adding every bigram into a 2D hash that also contains
                   #the number of times that specific bigram has appeared in the list of song titles.
                   for ($j = 0; $j < $#words; $j++) {
                       if (exists $frequency_bigrams{$words[$j]}{$words[$j+1]}) {
                           #if that bigram already exists, increases the count by one each time it appears
                            $frequency_bigrams{$words[$j]}{$words[$j+1]}++;
                           # print $words[$j], " ", $words[$j+1];
                           # print $frequency_bigrams{$words[$j]}{$words[$j+1]}, "\n";
                           }
                           else  {
                               #if that is the first occurance of the bigram, adds it into the hash containing 
                               #all of the different bigrams.
                                $frequency_bigrams{$words[$j]}{$words[$j+1]} = 0;
                               }
                               
                       }
                    }
                       
                }
        }
     }
 
}print($i, "\n");

# Close the file handle
close INFILE; 

# At this point (hopefully) you will have finished processing the song 
# title file and have populated your data structure of bigram counts.
print "File parsed. Bigram model built.\n\n";

#a function that finds the most common word that comes after a specific, entered word.
sub mcw {
    
        #$high, the number of times a bigram occurs, is reset to 0
        $high = 0;
        $mostcommon = $input;
        $counter = 0;
     
     #checks to make sure that word exists in any bigram in the data.
        if (!exists $frequency_bigrams{$input}) {
    }
    else {
         #iterate through the different bigrams, finding the one with the 
         #highest value, which would be the bigram starting with the entered word
         #that appears most frequently.
        foreach my $inner_key (keys%{$frequency_bigrams{$input}})    { 
            #counter can be used to find the number of bigrams that start with the 
            #entered word, but usually is not needed in most cases. 
            $counter++;
             if ($frequency_bigrams{$input}{$inner_key} > $high) {
                    $high = $frequency_bigrams{$input}{$inner_key};
                    $mostcommon = $inner_key;
                 }
        }
   #     print "$mostcommon ";
   #     print "$mostcommon appears $high times after $input \n";
  #      print "$counter bigrams start with that word\n";
    }
    return $mostcommon;
}

# User control loop, which has the user enter a word that the created song title will be based on
while ($input ne "q"){
    
      print "\nEnter a word [Enter 'q' to quit]: ";
      $input = <STDIN>;
      chomp($input);
      $input = lc($input);
      $title = $input;
       $mostcommon = mcw($input);
        $newcounter = 1;
        
        #only allows the title to be 20 words long, stops creating a title if it starts looping
        #and stops the loop if the user enters a 'q', showing that he or she wants to end the program.
        while ($newcounter < 19) {
            if ( $title =~ m/$mostcommon/|| $input eq 'q' || $input eq $mostcommon) {
                    $newcounter = 19;
                } else {
          #concatenates the string holding the title, adding new words as each most common bigram is found.
          $title .=" $mostcommon";
          $input = $mostcommon;\
          mcw($input);
                }
      }  
      
      print "$title \n";
}

