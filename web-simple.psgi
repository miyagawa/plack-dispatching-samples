use Web::Simple 'TestApp';

package TestApp;
use Plack::Request;
use Plack::Response;

sub dispatch_request {
    sub (GET + /) {
        my $res = Plack::Response->new(200);
        $res->content_type('text/plain');
        $res->content("Hello World");
        $res->finalize;
    },

    sub (GET + /blog/*/*) {
        my($self, $year, $month) = @_;
        my $res = Plack::Response->new(200);
        $res->content_type('text/html');
        $res->content("Blog posts from $year/$month");
        $res->finalize;
    },

    sub (POST + /comment + %*) {
        my($self, $params) = @_;
        my $res = Plack::Response->new(200);
        $res->content_type('text/plain');
        $res->content("Comment posted with body=" . $params->{body});
        $res->finalize;
    },

    sub (GET) {
        Plack::Response->new(404)->finalize;
    }
}

TestApp->to_psgi_app;

