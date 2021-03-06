#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Exception;
use FindBin;
use lib "$FindBin::Bin/../lib";

plan skip_all => 'must export launchpad credentials to enable these tests'
  unless $ENV{LP_CONSUMER_KEY}
  && $ENV{LP_ACCESS_TOKEN}
  && $ENV{LP_ACCESS_TOKEN_SECRET};

diag("testing people api");

# replace with the actual test
use_ok('Mojo::WebService::Launchpad::Client');

my $lp = Mojo::WebService::Launchpad::Client->new(
    consumer_key        => $ENV{LP_CONSUMER_KEY},
    access_token        => $ENV{LP_ACCESS_TOKEN},
    access_token_secret => $ENV{LP_ACCESS_TOKEN_SECRET}
);

use_ok('Mojo::WebService::Launchpad::Model::Person');

# person
my $person = await $lp->resource('Person')->by_name('~adam-stokes');
ok(
    $person->name eq 'adam-stokes',
    $person->name . " found correctly."
);

# my $query           = Net::Launchpad::Query->new( lpc => $lp );
# my $person_by_email = $query->people->get_by_email('adam.stokes@ubuntu.com');
my $person_by_fuzzy = await $lp->resource('Person')->find('adam-stokes');
ok(
    scalar @$person_by_fuzzy == 1,
    "a least one 'adam-stokes' found correctly."
);
# ok(
#     $person_by_email->result->{name} eq 'adam-stokes',
#     $person_by_email->result->{name} . " found correctly."
# );

done_testing;
