#!/usr/bin/perl
use strict;
use Plack::Request;

use lib "lib";

{
    package MyApp::Disptacher;
    use HTTPx::Dispatcher;
    connect '' => { controller => 'Hello', action => 'index'};
    connect 'blog/:year/:month' => { controller => 'Blog', action => 'monthly' };
    connect 'comment' => { controller => 'Blog', action => 'new_comment' };
}

{
    package MyApp::C::Hello;
    sub index {
        my ($class, $req, $p) = @_;
        my $res = $req->new_response(200);
        $res->content_type("text/plain");
        $res->content("Hello World");
        $res;
    }
}
{
    package MyApp::C::Blog;
    sub monthly {
        my($class, $req, $p) = @_;
        my $res = $req->new_response(200);
        $res->content_type('text/html');
        $res->content("Blog posts from $p->{year}/$p->{month}");
        $res;
    }
    sub new_comment {
        my($class, $req, $p) = @_;
        my $res = $req->new_response(200);
        $res->content_type('text/plain');
        $res->content("Comment posted with body=" . $req->parameters->{body});
        $res;
    }
}

sub {
    my $req   = Plack::Request->new(shift);
    my $match = MyApp::Disptacher->match($req)
        or return $req->new_response(404)->finalize;

    my $controller = "MyApp::C::$match->{controller}";
    my $action = $match->{action};
    my $res = $controller->$action($req, $match->{args});
    $res->finalize;
};
