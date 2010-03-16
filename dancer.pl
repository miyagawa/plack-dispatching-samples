# PSGI application bootstraper for Dancer
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
sub {
    my $request = Dancer::Request->new(shift);
    Dancer->dance($request);
};
