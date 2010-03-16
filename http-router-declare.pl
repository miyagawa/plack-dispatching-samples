#!/usr/bin/perl
use strict;
use Plack::Request;
use HTTP::Router::Declare;

use lib "lib";
use MyApp::Blog;
use MyApp::Hello;

my $router = router {
    match '/', { method => 'GET' }, to { action => sub {
        my($req, $p) = @_;
        my $res = $req->new_response(200);
        $res->content_type("text/plain");
        $res->content("Hello World");
        $res;
    } };
    match '/blog/{year}/{month}', { method => 'GET' }, to { action => sub {
        my($req, $p) = @_;
        my $res = $req->new_response(200);
        $res->content_type('text/html');
        $res->content("Blog posts from $p->{year}/$p->{month}");
        $res;
    } };
    match '/comment', { method => 'POST' }, to { action => sub {
        my($req, $p) = @_;
        my $res = $req->new_response(200);
        $res->content_type('text/plain');
        $res->content("Comment posted with body=" . $req->parameters->{body});
        $res;
    } };
};

sub {
    my $req   = Plack::Request->new(shift);
    my $match = $router->match($req)
        or return $req->new_response(404)->finalize;

    my $p = $match->params;
    my $res = $p->{action}->($req, $p);
    $res->finalize;
};
