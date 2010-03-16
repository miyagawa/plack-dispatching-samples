use Mojolicious::Lite;

get '/' => sub {
    my $self = shift;
    $self->res->headers->content_type('text/plain');
    $self->render_text("Hello World");
};

get '/blog/:year/:month' => sub {
    my $self = shift;
    $self->render_text("Blog posts from " . $self->stash('year') . "/" . $self->stash('month'));
};

post '/comment' => sub {
    my $self = shift;
    $self->render_text("Comment posted with body=" . $self->param('body'));
};

shagadelic('psgi');
