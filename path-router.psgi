use MyApp::Blog;
use MyApp::Hello;

use Path::Router;
use Plack::App::Path::Router;
use Moose::Util::TypeConstraints;

sub dispatch {
    my ($r) = @_;
    my $mapping = $r->env->{'plack.router.match'}->mapping;
    my $controller = 'MyApp::' . $mapping->{controller};
    my $action = $controller->can(lc($r->method) . '_' . $mapping->{action})
        or return $r->new_response(405);
    $controller->$action($r, $mapping);
}

my $router = Path::Router->new;
$router->add_route('/' => (
    defaults => {
        controller => 'Hello',
        action     => 'index',
    },
    target => \&dispatch
));

$router->add_route('/blog/:year/:month' => (
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

$router->add_route('/comment', => (
    defaults => {
        controller => 'Blog',
        action     => 'comment',
    },
    target => \&dispatch
));

Plack::App::Path::Router->new(router => $router)->to_app;
