use Plack::Request;
use Plack::Response;

use MyApp::Blog;
use MyApp::Hello;

use Path::Router;
use Moose::Util::TypeConstraints;

sub dispatch {
    my ($r, $mapping) = @_;
    my $controller = 'MyApp::' . $mapping->{controller};
    my $action = $controller->can(lc($r->method) . '_' . $mapping->{action})
        or return $r->new_response(405);
    $controller->$action($r, $mapping);
}

my $router = Path::Router->new;
$router->add_route('' => (
    defaults => {
        controller => 'Hello',
        action     => 'index',
    },
    target => \&dispatch
));

$router->add_route('blog/:year/:month' => (
    defaults => {
        controller => 'Blog',
        action     => 'monthly',
    },
    validations => {
        year  => subtype( as 'Int' => where { $_ > 0 } ),
        month => subtype( as 'Int' => where { $_ >= 1 && $_ <= 12 } ),
    },
    target => \&dispatch
));

$router->add_route('comment', => (
    defaults => {
        controller => 'Blog',
        action     => 'comment',
    },
    target => \&dispatch
));

sub {
    my $req = Plack::Request->new(shift);
    my $match = $router->match($req->path_info)
        or return $req->new_response(404)->finalize;

    my $res = $match->target->($req, $match->mapping);
    $res->finalize;
};
