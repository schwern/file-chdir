#!/usr/bin/perl -Tw

use strict;
use lib qw(t/lib);
use Test::More tests => 11;

BEGIN { use_ok('File::chdir') }

use Cwd;

# assemble directories the same way as File::chdir
BEGIN { *_catdir = \&File::chdir::ARRAY::_catdir };

# _catdir has OS-specific path separators so do the same for getcwd
sub _getcwd { File::Spec->canonpath( getcwd ) }

my $cwd = _getcwd;

ok( tied $CWD,      '$CWD is fit to be tied' );

# First, let's try unlocalized $CWD.
{
    $CWD = 't';
    ::is( _getcwd, _catdir($cwd,'t'), 'unlocalized $CWD works' );
    ::is( $CWD,   _catdir($cwd,'t'), '  $CWD set' );
}

::is( _getcwd, _catdir($cwd,'t'), 'unlocalized $CWD unneffected by blocks' );
::is( $CWD,   _catdir($cwd,'t'), '  and still set' );


# Ok, reset ourself for the real test.
$CWD = $cwd;

{
    my $old_dir = $CWD;
    local $CWD = "t";
    ::is( $old_dir, $cwd,           '$CWD fetch works' );
    ::is( _getcwd, _catdir($cwd,'t'), 'localized $CWD works' );
}

::is( _getcwd, $cwd,                 '  and resets automatically!' );
::is( $CWD,   $cwd,                 '  $CWD reset, too' );


chdir('t');
is( $CWD,   _catdir($cwd,'t'),       'chdir() and $CWD work together' );