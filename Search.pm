package Text::Search;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require AutoLoader;

@ISA = qw(Exporter AutoLoader);

$VERSION = '0.90';

sub new {
    my($class) = shift;
    my($self)  = {};
	
    bless( $self, $class );

	$self->_initialize();

    my (%hash)=@_;
    foreach my $key (keys( %hash ))
    {
        $self->{$key}=$hash{$key};
    }

	$self->{WebRoot} = $self->{DocumentRoot};

    return $self;
}

sub _initialize {
    my($self) = shift;

    $self->{UserSearchTerm} = undef;
    $self->{RegExSearch} = 0;
	$self->{DocumentRoot} = '/usr';
	$self->{WebRoot} = $self->{DocumentRoot};
	$self->{FileFilter} = '(^.*$)';
	$self->{HighlightBegin} = '<b>';
	$self->{HighlightEnd} = '</b>';
	$self->{Highlight} = 0;
	$self->{HTMLStrip} = 0;
	$self->{Recursive} = 1;
}

sub Find {
	my ($self) = shift;

	if ($self->{RegExSearch}) {
		@{$self->{SearchTerm}} = @_;
	}
	else {
		$self->{UserSearchTerm} = shift; 
		$self->_ParseUserSearchTerm;
	}
	
	my @_files = $self->_GetFilesList;
	my @_results = $self->_GetFileInfo(@_files);

	return @_results;
}

sub _ParseUserSearchTerm {
	my ($self) = shift;
	
	my $_SearchTerm = $self->{UserSearchTerm};

	# First, strip out extraneous white space (so '   client  blah   ' becomes 'client blah');
	$_SearchTerm =~ s/(\S+)\s*/$1 /g;
	chop $_SearchTerm;
	$_SearchTerm =~ /^\s*(.*)/;
	$_SearchTerm = $1;

	# Now quote any illegal characters;
	$_SearchTerm =~ s/[\`\!\@\#\$\%\^\&\*\(\)\{\}\[\]\'\"\;\:\,\.\<\>\/\?\+\-\=\|\\\~]/\\$&/g;

	$_SearchTerm = "(" . $_SearchTerm . ")";

	$_SearchTerm =~ s/\s+OR\s+/)|(/g;
	$_SearchTerm =~ s/\s+AND\s+/) AND (/g;

	@{$self->{SearchTerm}} =  split /\s+AND\s+/, $_SearchTerm;
}

sub _GetFileInfo {
	my ($self) = shift;
	my @_files = @_;
	
	my @_results;

	foreach (@_files) 
	{
		chomp $_;
		my $_record = {};
		my $_skipfile = 0;   # Set to 1 if this file is not to be included
		
		open(FILE, "< $_") or die "Couldn't open $_ for reading: $!\n";
		my @_info = stat(FILE);
	    my $_file = '';
		read(FILE, $_file, $_info[7]);
		close (FILE);

		my $contents = $_file;
		
		### Strip HTML elements if desired
		$contents =~ s/<(.*?)>//sg if ($self->{HTMLStrip});

		my $_count = 0;
		my $_CurrentTerm;
		my $_Match = 1;
		foreach $_CurrentTerm (@{$self->{SearchTerm}}) { 
			if ( $contents =~ /$_CurrentTerm/i ) {
				while ( $contents =~ /($_CurrentTerm)/sgi ) { $_count++; }
			}
			else {
				$_Match=0;
			}
		}
		
		$contents = $_file;
		
		if ($_count > 0 && $_Match == 1) {
			### Grab info about the page

			### Grab HTML info
			if ($contents =~ /<title>(.*?)<\/title>/is) { $_record->{'TITLE'} = $1 }
				else { $_record->{'TITLE'} = '' }
			if ($contents =~ /<meta\s+name\s*=\s*\"title\"\s+content\s*=\s*\"(.*?)\"\s*>/is ) { $_record->{'META_TITLE'} = $1 }
				else { $_record->{'META_TITLE'} = '' }
			if ($contents =~ /<meta\s+name\s*=\s*\"description\"\s+content\s*=\s*\"(.*?)\"\s*>/is ) { $_record->{'META_DESCRIPTION'} = $1 }
				else { $_record->{'META_DESCRIPTION'} = '' }
			if ($contents =~ /<meta\s+name\s*=\s*\"keywords\"\s+content\s*=\s*\"(.*?)\"\s*>/is ) { $_record->{'META_KEYWORDS'} = $1 }
				else { $_record->{'META_KEYWORDS'} = '' }
			### Grab other info
			$_record->{'FULLNAME'} = $_;
			/(.*)\/(.*)$/; # Match the Pathname and the filename
			$_record->{'FILEPATH'} = $1;
			$_record->{'FILENAME'} = $2;
			$_record->{'FILESIZE'} = $_info[7];
			$_record->{'FILEKSIZE'} = sprintf("%.2f",$_info[7] / 1024);
			$_record->{'LAST_MODIFIED_EPOCH'} = $_info[9];
			$_record->{'LAST_MODIFIED'} = localtime($_info[9]);
			$_record->{'OCCURENCES'} = $_count;
			$contents =~ /[\w\,\'\`\-\s]*(($self->{SearchTerm}[0])[\w\,\.\'\-]*(\s([\w\,\.\'\-]*)){0,15})/si;
			$& =~ /^[\,\.\s]*/;
			$_record->{'SNIPPET'} = $';
			$_record->{'URL'} = $_;
			$_record->{'URL'} =~ s/$self->{WebRoot}//s;
			
			#### Highlight Snippet text if desired.
			if ($self->{Highlight}) {
				foreach $_CurrentTerm (@{$self->{SearchTerm}}) { $_record->{'SNIPPET'} =~ s/$_CurrentTerm/$self->{HighlightBegin}$&$self->{HighlightEnd}/ig }
			}

			push @_results, $_record unless ($_skipfile);
		}
	}

	### Sort the results by Most occurences first.
	@_results = sort { $b->{'OCCURENCES'} <=> $a->{'OCCURENCES'} } @_results;

	return @_results;
}

sub _GetFilesList {
	my ($self) = shift;

	use File::Find;

	my @_found;
	my $_wanted = sub { if ( -T && /$self->{FileFilter}/) { if ( $self->{Recursive} || $File::Find::name !~ /^$self->{DocumentRoot}\/.+\//) { push (@_found,"$File::Find::name\n") } } };

	File::Find::find(\&$_wanted, $self->{DocumentRoot});
	
	return @_found;
}


1;


__END__



=head1 NAME

B<Text::Search> - Perl module to allow quick searching of directories for given text.

Version 0.90

=head1 SYNOPSIS

use Text::Search;


Simple Search:
my $term = 'foo AND bar';

my $search = Text::Search->new();
my @results = $search->Find($term);

foreach (@results) { print "Found $term in $_->{'FILENAME'} $_->{'OCCURENCES'} times.\n" };

RegEx Search:
my @terms = ('(foo.*)','(bar)');

my $search = Text::Search->new(RegExSearch = '1');
my @results = $search->Find(@terms);

foreach (@results) { print "Found $_->{'FILENAME'} with $_->{'OCCURENCES'}.\n" };


=head1 DESCRIPTION

B<Text::Search> takes in a given directory and search term, and will recursively
search for all occurences for the term. Features include: extension filtering, 
binary filter (won't search binary files), simple and regex search expressions.

Information is returned as an array of hashes sorted descending by number of occurences.

=head1 CONSTRUCTORS

=over 2

=item C<Text::Search-E<gt>new()>

C<$search = Text::Search-E<gt>new([RegExSearch =E<gt> '1'], [DocumentRoot =E<gt> '/usr/home/mike'], [FileFilter =E<gt> '(^.*\.htm*$)'] );>

Prepares a search to be performed. The search will execute with a $search-E<gt>Find().

RegExSearch = Set to 1 if this is to be a regular expression search. 0 if this is a simple search. (Default)

DocumentRoot = Where to begin the search from, search is recursive. Default is (/usr).

WebRoot = For use with a website. Only needs to be set if your DocumentRoot is set to something other than your WebRoot.

FileFilter = Regular expression to filter out unwanted files. Default is all files.

Recursive = Set to 0 to turn off recursive searching. Default is 1.

Highlight = Set to 1 to turn on Highlighting of matched words. Useful for bolding matched text in websites. Default is 0.

HighlightBegin = Customize the code to appear before a match. Default is '<b>'.

HighlightEnd = Customize the code to appear after a match. Default is '</b>'.

=item C<$search-E<gt>Find()>

C<@results = $search-E<gt>Find('blowfish OR foo AND bar');>
C<@results = $search-E<gt>Find('(blowfish)|(foo)','(bar)');>

Executes a search for the given terms.

Data is returned in an array of hashes which can be accessed like so:

C<foreach (@results) { print "$_-E<gt>{'FILENAME'} : $_-E<gt>{'FILEKSIZE'} : $_-E<gt>{'LAST_MODIFIED'} : $_-E<gt>{'OCCURENCES'}\n" };>

OR

C<print "Most likely target is $results[0]{'FILENAME'}\n";>

The following keys are available in the returned hash:

FULLNAME = Full path and filename of file. (ie. /home/doug/readme.txt)

FILENAME = Name of the file (ie. readme.txt)

FILEPATH = Path to the file (ie. /home/doug)

FILESIZE = Size of file in bytes.

FILEKSIZE = Size of file in kilobytes.

LAST_MODIFIED_EPOCH = Time since file was last modified in seconds.

LAST_MODIFIED = Date and Time of last modified in long format.

OCCURENCES = Number of times the search pattern was matched.

URL = For Website use, the path and filename of file from the given DocumentRoot.

SNIPPET = Snippet of text containing text of the first matched term.

TITLE = Pulled from the <TITLE> tag of an HTML page.

META_TITLE = Pulled from the <meta name="title"> tag.

META_DESCRIPTION = Pulled from the <meta name="description"> tag.

META_KEYWORDS = Pulled from the <meta name="keywords"> tag.


=head1 EXAMPLES

=head2 Simple script usage.

use Text::Search;

my $search = Text::Search-E<gt>new(DocumentRoot => '/usr/home/bill/ebooks');

print "Searching:\n\n";

my @results = $search-E<gt>Find('romeo AND juliette');

foreach (@results) { print "Found it $_-E<gt>{'OCCURENCES'} times in $_-E<gt>{'FILENAME'}\n" };

=head2 Web based application.

This is an excellent way to add a search engine to any html site.

require ("cgi-lib.pl");
use Text::Search;

&ReadParse (*input);

my $search = Text::Search-E<gt>new(DocumentRoot => $ENV{'DOCUMENT_ROOT'}, FileFilter => '(^.*\.html$)');

my @results = $search-E<gt>Find($input{'User_Search'});

print "Content-type: text/html \n\n";

print "Sorry, I couldn't find your request!" if (scalar @results == 0);

foreach (@results) { print "E<lt>a href=\"$_-E<gt>{'URL'}\"E<gt>$_-E<gt>{'URL'}E<lt>/aE<gt>E<lt>brE<gt>Relevancy: $_-E<gt>{'OCCURENCES'}E<lt>brE<gt>Last Updated: $_-E<gt>{'LAST_MODIFIED'}E<lt>brE<gt>E<lt>hrE<gt>\n" };

=head1 BUGS

Be careful when using simple search. It will attemp to quote any illegal characters, etc. But for security sake, do your own checks before passing user input into the simple search.

If you have trouble with the HTML grabbing (ie. Title tags, Meta tags), take a look at the syntax of the HTML document. Text::Search tries to be forgiving, but it expects something like this:

<title>This is my title</title>

<meta name="description" content="This is my wonderful website">

=head1 DISCLAIMER

This package is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.

=head1 COPYRIGHT

Copyright (c) 2001 Mike Miller.
All rights reserved.

=head1 LICENSE

This program is free software: you can redistribute it
and/or modify it under the same terms as Perl itself.

=head1 AUTHOR

Mike Miller
<mrmike@2bit.net>

=back

=cut

