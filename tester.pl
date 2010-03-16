use Plack::Test;
use Plack::Util;
use HTTP::Request::Common;
use Test::More;

my $app = Plack::Util::load_psgi($ARGV[0]);

test_psgi $app, sub {
    my $cb = shift;

    my $res = $cb->(GET "/");
    like $res->content, qr/Hello World/;

    $res = $cb->(GET "/blog/2010/02");
    like $res->content, qr/Blog posts from 2010\/02/;

    $res = $cb->(POST "/comment", { name => "miyagawa", body => "Awesome blog!" });
    like $res->content, qr/body=Awesome blog!/;

    $res = $cb->(GET "/nonexistent");
    is $res->code, 404;
};

done_testing;



