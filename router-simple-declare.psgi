#!/usr/bin/perl
use strict;
use Plack::Request;
use Router::Simple::Declare;
use MyApp::Blog;
use MyApp::Hello;

my $router = router {
    connect '/',
        { controller => 'Hello', action => 'index' }, { method => 'GET' };
    connect '/blog/{year}/{month}',
        { controller => 'Blog', action => 'monthly' }, { method => 'GET' };
    connect '/comment',
        { controller => 'Blog', action => 'comment' }, { method => 'POST' };
};

sub {
    my $req   = Plack::Request->new(shift);
    my $p     = $router->match($req)
        or return $req->new_response(404)->finalize;

    my $controller = "MyApp::" . $p->{controller};
    my $action = $controller->can(lc($req->method) . "_" . $p->{action});
    my $res = $controller->$action($req, $p->{args});
    $res->finalize;
};
