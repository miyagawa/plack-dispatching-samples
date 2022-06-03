use Dancer::Config 'setting';
setting apphandler  => 'PSGI';
Dancer::Config->load;

use Dancer;

get '/' => sub {
    content_type 'text/plain';
    return "Hello World";
};

get r('/blog/(\d{4})/(\d{2})') => sub {
    my($year, $month) = splat;
    return "Blog posts from $year/$month";
};

post '/comment' => sub {
    return "Comment posted with body=" . params->{body};
};

# return PSGI app
sub { Dancer->dance( Dancer::Request->new( env => shift ) ) };
