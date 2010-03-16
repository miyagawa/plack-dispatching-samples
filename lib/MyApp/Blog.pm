package MyApp::Blog;

sub get_monthly {
    my($class, $req, $p) = @_;

    my $res = $req->new_response(200);
    $res->content_type('text/html');
    $res->content("Blog posts from $p->{year}/$p->{month}");

    $res;
}

sub post_comment {
    my($class, $req, $p) = @_;

    my $res = $req->new_response(200);
    $res->content_type('text/plain');
    $res->content("Comment posted with body=" . $req->parameters->{body});

    $res;
}

1;

