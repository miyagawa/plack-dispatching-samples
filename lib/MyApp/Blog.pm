package MyApp::Blog;

sub monthly {
    my($class, $req, $p) = @_;

    my $res = $req->new_response(200);
    $res->content_type('text/html');
    $res->content("Blog posts from $p->{year}/$p->{month}");

    $res;
}

sub new_comment {
    my($class, $req, $p) = @_;

    my $res = $req->new_response(200);
    $res->content_type('text/plain');
    $res->content("Comment posted with body=" . $req->parameters->{body});

    $res;
}

1;

