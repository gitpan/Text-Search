#!/usr/bin/perl -w

use Test;

BEGIN { plan tests => 26 }

use Text::Search;

my $path = '/tmp';

mkdir '/tmp/testdirectoryperltextsearch' or die "Couldn't create /tmp/testdirectoryperltextsearch for writing: $!\n";

### Create files required for testing
open(SOURCE, "> /tmp/testfile1.textsearchperlmodule") or die "Couldn't open $path for writing: $!\n";
print SOURCE <<SOURCEEND;
	<title>Twelfth Night - Act II Scene III</title>
	Sir Andrew:
	By my troth, the fool has an excellent breast. I
	had rather than forty shillings I had such a leg,
	and so sweet a breath to sing, as the fool has. In
	sooth, thou wast in very gracious fooling last
	night, when thou spokest of Pigrogromitus, of the
	Vapians passing the equinoctial of Queubus: 'twas
	very good, i' faith. I sent thee sixpence for thy
	leman: hadst it?
SOURCEEND
close (SOURCE);

open(SOURCE, "> /tmp/testfile2.textsearchperlmodule") or die "Couldn't open $path for writing: $!\n";
print SOURCE <<SOURCEEND; 
	<TITLE>Merchant of Venice - Act IV Scene I</TITLE>
	<meta naMe = "title" conTENt="Merchant of Venice - Act IV Scene I">
	<META NAME="DESCRIPTION" content = "Comedy by William Shakespeare"  >
	<MeTa  name="keywords"  content ="shakespeare antonio shylok">
	Antonio:
	I pray you, think you question with the Jew:
	You may as well go stand upon the beach
	And bid the main flood bate his usual height;
	You may as well use question with the wolf
	Why he hath made the ewe bleat for the lamb;
	You may as well forbid the mountain pines
	To wag their high tops and to make no noise,
	When they are fretten with the gusts of heaven;
	You may as well do anything most hard,
	As seek to soften that--than which what's harder?--
	His Jewish heart: therefore, I do beseech you,
	Make no more offers, use no farther means,
	But with all brief and plain conveniency
	Let me have judgment and the Jew his will.
SOURCEEND 
close (SOURCE); #'

open(SOURCE, "> /tmp/testfile3.textsearchperlmodule") or die "Couldn't open $path for writing: $!\n";
print SOURCE <<SOURCEEND;
	MacBeth - Act V Scene I
	Lady MacBeth
	Out, damned spot! out, I say!--One: two: why,
	then, 'tis time to do't.--Hell is murky!--Fie, my
	lord, fie! a soldier, and afeard? What need we
	fear who knows it, when none can call our power to
	account?--Yet who would have thought the old man
	to have had so much blood in him.
SOURCEEND
close (SOURCE);

open(SOURCE, "> /tmp/testfile4.textsearchperlmodule") or die "Couldn't open $path for writing: $!\n";
print SOURCE <<SOURCEEND;
	Hamlet - Act III Scene I
	Hamlet
	To be, or not to be: that is the question:
	Whether 'tis nobler in the mind to suffer
	The slings and arrows of outrageous fortune,
	Or to take arms against a sea of troubles,
	And by opposing end them? To die: to sleep;
	No more; and by a sleep to say we end
	The heart-ache and the thousand natural shocks
	That flesh is heir to, 'tis a consummation
	Devoutly to be wish'd. To die, to sleep;
	To sleep: perchance to dream: ay, there's the rub;
	For in that sleep of death what dreams may come
	When we have shuffled off this mortal coil,
	Must give us pause: there's the respect
	That makes calamity of so long life;
	For who would bear the whips and scorns of time,
	The oppressor's wrong, the proud man's contumely,
	The pangs of despised love, the law's delay,
	The insolence of office and the spurns
	That patient merit of the unworthy takes,
	When he himself might his quietus make
	With a bare bodkin? who would fardels bear,
	To grunt and sweat under a weary life,
	But that the dread of something after death,
	The undiscover'd country from whose bourn
	No traveller returns, puzzles the will
	And makes us rather bear those ills we have
	Than fly to others that we know not of?
	Thus conscience does make cowards of us all;
	And thus the native hue of resolution
	Is sicklied o'er with the pale cast of thought,
	And enterprises of great pith and moment
	With this regard their currents turn awry,
	And lose the name of action.--Soft you now!
	The fair Ophelia! Nymph, in thy orisons
	Be all my sins remember'd.
SOURCEEND
close (SOURCE); #'

open(SOURCE, "> /tmp/testdirectoryperltextsearch/testfile5.textsearchperlmodule") or die "Couldn't open $path for writing: $!\n";
print SOURCE <<SOURCEEND;
	Shakespeare's Sonnets.
	CXL.

	Be wise as thou art cruel; do not press
	My tongue-tied patience with too much disdain;
	Lest sorrow lend me words and words express
	The manner of my pity-wanting pain.
	If I might teach thee wit, better it were,
	Though not to love, yet, love, to tell me so;
	As testy sick men, when their deaths be near,
	No news but health from their physicians know;
	For if I should despair, I should grow mad,
	And in my madness might speak ill of thee:
	Now this ill-wresting world is grown so bad,
	Mad slanderers by mad ears believed be,
	  That I may not be so, nor thou belied,
	  Bear thine eyes straight, though thy proud heart go wide.
SOURCEEND
close (SOURCE); #'

open(SOURCE, "> /tmp/testdirectoryperltextsearch/testfile6.textsearchperlmodule") or die "Couldn't open $path for writing: $!\n";
print SOURCE <<SOURCEEND;
	Julius Caesar - Act IV Scene III
	Brutus
	There is a tide in the affairs of men, 
	Which, taken at the flood, leads on to fortune: 
	Omitted, all the voyage of their life 
	Is bound in shallows and in miseries. 
	On such a full sea are we now afloat, 
	And we must take the current when it serves, 
	Or lose our ventures. 
SOURCEEND
close (SOURCE); #'

open(SOURCE, "> /tmp/testdirectoryperltextsearch/testfile7.textsearchperlmodule") or die "Couldn't open $path for writing: $!\n";
print SOURCE <<SOURCEEND;
	The Tempest - Act IV Scene I
	Prospero
	Our revels now are ended. These our actors, 
	As I foretold you, were all spirits and 
	Are melted into air, into thin air; 
	And - like the baseless fabric of this vision - 
	The cloud-capp'd towers, the gorgeous palaces, 
	The solemn temples, the great globe itself, 
	Yea, all which it inherit, shall dissolve, 
	And like this insubstantial pageant faded, 
	Leave not a rack behind. We are such stuff 
	As dreams are made on, and our little life 
	Is rounded with a sleep. 
SOURCEEND
close (SOURCE); #'

open(SOURCE, "> /tmp/testdirectoryperltextsearch/testfile8.textsearchperlmodule") or die "Couldn't open $path for writing: $!\n";
print SOURCE <<SOURCEEND;
	As You Like It - Act IV Scene I
	Rosalind
	No, faith, die by attorney. The poor world is
	almost six thousand years old, and in all this time
	there was not any man died in his own person,
	videlicit, in a love-cause. Troilus had his brains
	dashed out with a Grecian club; yet he did what he
	could to die before, and he is one of the patterns
	of love. Leander, he would have lived many a fair
	year, though Hero had turned nun, if it had not been
	for a hot midsummer night; for, good youth, he went
	but forth to wash him in the Hellespont and being
	taken with the cramp was drowned and the foolish
	coroners of that age found it was 'Hero of Sestos.'
	But these are all lies: men have died from time to
	time and worms have eaten them, but not for love.
SOURCEEND
close (SOURCE); #'


### Do some basic searches.
$search = Text::Search->new(DocumentRoot => '/tmp', FileFilter => '(^.*\.textsearchperlmodule$)');
@results = $search->Find('blech');
ok(scalar(@results) == 0);

@results = $search->Find('die');
ok(scalar(@results) == 3);
ok($results[0]{'OCCURENCES'} == 4);
ok($results[0]{'FULLNAME'} eq '/tmp/testdirectoryperltextsearch/testfile8.textsearchperlmodule');
ok($results[0]{'FILEPATH'} eq '/tmp/testdirectoryperltextsearch');
ok($results[0]{'FILENAME'} eq 'testfile8.textsearchperlmodule');
ok($results[2]{'OCCURENCES'} == 2);
ok($results[2]{'URL'} eq '/testfile4.textsearchperlmodule');
ok($results[2]{'SNIPPET'} eq 'To die');


### Now test the AND and OR
@results = $search->Find('youth OR turn');
ok(scalar(@results) == 2);
ok($results[0]{'OCCURENCES'} == 2);
@results = $search->Find('what AND of');
ok(scalar(@results) == 3);
ok($results[0]{'OCCURENCES'} == 19);


### Now test RegEx Matching
$search = Text::Search->new(DocumentRoot => '/tmp', FileFilter => '(^.*\.textsearchperlmodule$)', RegExSearch => '1');
@results = $search->Find('(worms)|(from)');
ok(scalar(@results) == 3);
ok($results[0]{'OCCURENCES'} == 2);

@results = $search->Find('(and)','(cramp)|(men)');
ok(scalar(@results) == 5);
ok($results[0]{'OCCURENCES'} == 14);


### Now Test Recursive and Non-Recursive
$search = Text::Search->new(DocumentRoot => '/tmp', FileFilter => '(^.*\.textsearchperlmodule$)', Recursive => '0');
@results = $search->Find('As You Like It');
ok(scalar(@results) == 0);

$search = Text::Search->new(DocumentRoot => '/tmp', FileFilter => '(^.*\.textsearchperlmodule$)', Recursive => '1');
@results = $search->Find('As You Like It');
ok(scalar(@results) == 1);

### Now test HTML Stripping
$search = Text::Search->new(DocumentRoot => '/tmp', FileFilter => '(^testfile1\.textsearchperlmodule$)', HTMLStrip => '0');
@results = $search->Find('title');
ok(scalar(@results) == 1);

$search = Text::Search->new(DocumentRoot => '/tmp', FileFilter => '(^testfile1\.textsearchperlmodule$)', HTMLStrip => '1');
@results = $search->Find('title');
ok(scalar(@results) == 0);


### Now test for HTML Grabbing... <title> <meta name="title" content="...."> and <meta name="keywords" content="...."
$search = Text::Search->new(DocumentRoot => '/tmp', FileFilter => '(^testfile2\.textsearchperlmodule$)');
@results = $search->Find('Merchant of Venice');
ok($results[0]{'TITLE'} eq 'Merchant of Venice - Act IV Scene I');
ok($results[0]{'META_TITLE'} eq 'Merchant of Venice - Act IV Scene I');
ok($results[0]{'META_DESCRIPTION'} eq 'Comedy by William Shakespeare');
ok($results[0]{'META_KEYWORDS'} eq 'shakespeare antonio shylok');

### Now test for Snippet Highlighting
$search = Text::Search->new(DocumentRoot => '/tmp', FileFilter => '(^testfile4\.textsearchperlmodule$)', Highlight => '1', HighlightBegin => '<b>', HighlightEnd => '</b>');
@results = $search->Find('die');
ok($results[0]{'SNIPPET'} eq 'To <b>die</b>');


unlink '/tmp/testfile1.textsearchperlmodule','/tmp/testfile2.textsearchperlmodule','/tmp/testfile3.textsearchperlmodule','/tmp/testfile4.textsearchperlmodule','/tmp/testdirectoryperltextsearch/testfile5.textsearchperlmodule','/tmp/testdirectoryperltextsearch/testfile6.textsearchperlmodule','/tmp/testdirectoryperltextsearch/testfile7.textsearchperlmodule','/tmp/testdirectoryperltextsearch/testfile8.textsearchperlmodule';
rmdir '/tmp/testdirectoryperltextsearch';
