use Plack::Request;
use Plack::Response;

use MyApp::Blog;
use MyApp::Hello;

use Path::Router;
use Moose::Util::TypeConstraints;

my $router = Path::Router->new;
$router->add_route('' => (
    defaults => {
        controller => 'Hello',
        action     => 'index',
    },
));

$router->add_route('blog/:year/:month' => (
    defaults => {
        controller => 'Blog',
        action     => 'monthly',
    },
    validations => {
        year  => subtype( as 'Int' => where { $_ > 0 } ),
        month => subtype( as 'Int' => where { $_ >= 1 && $_ <= 12 } ),
    }
));

$router->add_route('comment', => (
    defaults => {
        controller => 'Blog',
        action     => 'comment',
    },
));

sub {
    my $req = Plack::Request->new(shift);
    my $match = $router->match($req->path_info)
        or return $req->new_response(404)->finalize;

    my $mapping = $match->mapping;
    my $controller = "MyApp::" . $mapping->{controller};
    my $action = $controller->can(lc($req->method) . "_" . $mapping->{action})
        or return $req->new_response(405)->finalize;
    my $res = $controller->$action($req, $mapping);
    $res->finalize;
};
