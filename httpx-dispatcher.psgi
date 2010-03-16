#!/usr/bin/perl
use strict;
use Plack::Request;

use MyApp::Hello;
use MyApp::Blog;

{
    package MyApp::Disptacher;
    use HTTPx::Dispatcher;
    connect '' => { controller => 'Hello', action => 'index'};
    connect 'blog/:year/:month' => { controller => 'Blog', action => 'monthly' };
    connect 'comment' => { controller => 'Blog', action => 'comment' };
}

sub {
    my $req   = Plack::Request->new(shift);
    my $match = MyApp::Disptacher->match($req)
        or return $req->new_response(404)->finalize;

    my $controller = "MyApp::$match->{controller}";
    my $action = $controller->can(lc($req->method) . "_" . $match->{action})
        or return $req->new_response(405)->finalize;
    my $res = $controller->$action($req, $match->{args});
    $res->finalize;
};
