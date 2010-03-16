use Plack::Request;
use Plack::Response;

{
    package MyApp::Dispatcher;
    use Path::Dispatcher::Declarative -base, -default => {
        token_delimiter => '/',
    };

    on [] => sub {
        my $res = Plack::Response->new(200);
        $res->content_type('text/plain');
        $res->content("Hello World");
        $res
    };

    under { REQUEST_METHOD => 'GET' } => sub {
        on ['blog', qr/^\d+$/, qr/^\d+$/] => sub {
            my $res = Plack::Response->new(200);
            $res->content_type('text/html');
            $res->content("Blog posts from $2/$3");
            $res
        };
    };

    under { REQUEST_METHOD => 'POST' } => sub {
        on 'comment' => sub {
            my $req = shift;
            my $res = Plack::Response->new(200);
            $res->content_type('text/plain');
            $res->content("Comment posted with body=" . $req->param('body'));
            $res
        };
    };
}

sub {
    my $req = Plack::Request->new(shift);
    my $path = Path::Dispatcher::Path->new(
        path     => $req->path_info,
        metadata => $req->env,
    );

    my $dispatch = MyApp::Dispatcher->dispatch($path);
    return Plack::Response->new(404)->finalize if !$dispatch->has_matches;

    my $res = $dispatch->run($req);
    $res->finalize;
};

