#!/usr/bin/env perl

use strict;
use warnings;

BEGIN {
	use File::Copy::Recursive qw'dircopy pathrmdir';
	use File::Spec::Functions qw'catdir catfile';
	use File::Which 'which';
	use FindBin '$Bin';
	use lib catdir $Bin,'svn';

	use Test::More;
	if ( which 'svn' ) {
		plan tests => 3;
	} else {
		plan skip_all => 'no svn executable found';
	}

	pathrmdir catfile $Bin,'svn','.svn';
	dircopy catfile($Bin,'svn','dot-svn') => catfile($Bin,'svn','.svn') or die $!;
}

use Catalyst::Test 'TestApp';


is( get('/'), 'ok', 'index' );
is( get('/none'), 'not found', 'nonexistent' );
is( get('/revision'), '18', 'revision' );

END {
	pathrmdir catfile $Bin,'svn','.svn' or die $!;
}

