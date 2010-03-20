#!/usr/bin/perl
use strict;
use Plack::Request;
use Plack::Response;
use Router::Simple 0.03;
use Router::Simple::Declare;
use MyApp::Blog;
use MyApp::Hello;

my $router = router {
    connect '/',
        { controller => 'Hello', action => 'index' }, { method => 'GET' };
    connect '/blog/{year:\d{4}}/{month:\d{2}}',
        { controller => 'Blog', action => 'monthly' }, { method => 'GET' };
    connect '/comment',
        { controller => 'Blog', action => 'comment' }, { method => 'POST' };
};

sub {
    my $env = shift;
    my $p   = $router->match($env)
        or return Plack::Response->new(404)->finalize;

    my $req = Plack::Request->new($env);
    my $controller = "MyApp::" . delete $p->{controller};
    my $action = $controller->can(lc($req->method) . "_" . delete $p->{action});
    my $res = $controller->$action($req, $p);
    $res->finalize;
};
