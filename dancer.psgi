# NOTE: Dancer doesn't use Plack::Request - here's for a comparison

use Dancer::Config 'setting';
setting apphandler  => 'PSGI';
Dancer::Config->load;

use Dancer;

get '/' => sub {
    content_type 'text/plain';
    return "Hello World";
};

get '/blog/:year/:month' => sub {
    return "Blog posts from " . params->{year} . "/" . params->{month};
};

post '/comment' => sub {
    return "Comment posted with body=" . params->{body};
};

# return PSGI app
sub { Dancer->dance( Dancer::Request->new(shift) ) };
