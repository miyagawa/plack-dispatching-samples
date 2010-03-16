use Plack::Test;
use Plack::Util;
use HTTP::Request::Common;
use Test::More;

$ENV{PLACK_ENV} = 'development';
my $app = Plack::Util::load_psgi($ARGV[0]);

test_psgi $app, sub {
    my $cb = shift;

    my $res = $cb->(GET "/");
    is $res->content_type, 'text/plain';
    like $res->content, qr/Hello World/;

    $res = $cb->(GET "/blog/2010/02");
    is $res->content_type, 'text/html';
    like $res->content, qr/Blog posts from 2010\/02/;

    $res = $cb->(POST "/blog/2009/01");
    ok $res->is_error;

    $res = $cb->(POST "/comment", { name => "miyagawa", body => "Awesome blog!" });
    like $res->content, qr/body=Awesome blog!/;

    $res = $cb->(GET "/nonexistent");
    is $res->code, 404;
};

done_testing;



