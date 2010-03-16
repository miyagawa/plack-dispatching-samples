use Plack::Request;
use Plack::Response;

use MyApp::Blog;
use MyApp::Hello;

{
    package MyApp::Dispatcher;
    use Path::Dispatcher::Declarative -base, -default => {
        token_delimiter => '/',
    };

    on [] => sub { MyApp::Hello->get_index(@_) };

    under { REQUEST_METHOD => 'GET' } => sub {
        on ['blog', qr/^\d+$/, qr/^\d+$/] => sub {
            MyApp::Blog->get_monthly(shift, { year => $2, month => $3 });
        };
    };

    under { REQUEST_METHOD => 'POST' } => sub {
        on 'comment' => sub {
            MyApp::Blog->post_comment(@_);
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

