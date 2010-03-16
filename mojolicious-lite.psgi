use Mojolicious::Lite;

get '/' => sub {
    my $self = shift;
    $self->render_text("Hello World", format => 'txt');
};

get '/blog/:year/:month' => [ year => qr/\d{4}/, month => qr/\d{2}/ ], sub {
    my $self = shift;
    $self->render_text("Blog posts from " . $self->stash('year') . "/" . $self->stash('month'));
};

post '/comment' => sub {
    my $self = shift;
    $self->render_text("Comment posted with body=" . $self->param('body'));
};

shagadelic;
