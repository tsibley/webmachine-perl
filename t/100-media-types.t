#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('Web::Machine::Util::MediaType');
}

{
    my $parsed_media_type = Web::Machine::Util::MediaType->parse('application/xml;charset=UTF-8');
    isa_ok($parsed_media_type, 'Web::Machine::Util::MediaType');

    is($parsed_media_type->type, 'application/xml', '... got the right type');
    is_deeply(
        $parsed_media_type->params,
        { 'charset' => 'UTF-8' },
        '... got the right params'
    );

    is($parsed_media_type->major, 'application', '... got the right major portion');
    is($parsed_media_type->minor, 'xml', '... got the right minor portion');

    my $media_type = Web::Machine::Util::MediaType->new(
        type   => 'application/xml',
        params => { 'charset' => 'UTF-8' }
    );
    isa_ok($media_type, 'Web::Machine::Util::MediaType');

    ok($parsed_media_type->equals( $media_type ), '... these types are equal');
    ok($parsed_media_type->equals('application/xml;charset=UTF-8'), '... these types are equal');

    ok(!$parsed_media_type->matches_all, '... this is not a matches_all type');

    ok($parsed_media_type->exact_match('application/xml;charset=UTF-8'), '... these types are an exact match');
    ok($parsed_media_type->exact_match('application/*;charset=UTF-8'), '... these types are an exact match');
    ok($parsed_media_type->exact_match('*/*;charset=UTF-8'), '... these types are an exact match');

    ok($parsed_media_type->match('application/xml;charset=UTF-8;version=1'), '... these types are a match');
    ok($parsed_media_type->match('application/*;charset=UTF-8;version=1'), '... these types are a match');
    ok($parsed_media_type->match('*/*;charset=UTF-8;version=1'), '... these types are a match');
}

{
    my $matches_all = Web::Machine::Util::MediaType->parse('*/*');

    is($matches_all->type, '*/*', '... got the right type');
    is_deeply(
        $matches_all->params,
        {},
        '... got the right params'
    );

    ok($matches_all->matches_all, '... this type does match all');
}

{
    my $matches_all = Web::Machine::Util::MediaType->parse(q[multipart/form-data;
boundary=----------------------------2c46a7bec2b9]);

    is($matches_all->type, 'multipart/form-data', '... got the right type');
    is_deeply(
        $matches_all->params,
        { 'boundary' => '----------------------------2c46a7bec2b9' },
        '... got the right params'
    );
}

done_testing;