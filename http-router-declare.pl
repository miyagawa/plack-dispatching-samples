#!/usr/bin/perl
use strict;
use Plack::Request;
use HTTP::Router::Declare;

use lib "lib";
use MyApp::Blog;
use MyApp::Hello;

my $router = router {
    match '/', { method => 'GET' },
        to { controller => 'Hello', action => 'index' };
    match '/blog/{year}/{month}', { method => 'GET' },
        to { controller => 'Blog', action => 'monthly' };
    match '/comment', { method => 'POST' },
        to { controller => 'Blog', action => 'new_comment' };
};

sub {
    my $req   = Plack::Request->new(shift);
    my $match = $router->match($req)
        or return $req->new_response(404)->finalize;

    my $p = $match->params;
    my $controller = "MyApp::$p->{controller}";
    my $action = $p->{action};
    my $res = $controller->$action($req, $p);
    $res->finalize;
};
