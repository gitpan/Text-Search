use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'	=> 'Text::Search',
    'VERSION_FROM' => 'Search.pm',
    'dist'	=> {COMPRESS=>'gzip', SUFFIX=>'gz'},
);
