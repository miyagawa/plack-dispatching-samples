package MyApp::Hello;

sub get_index {
    my($class, $req) = @_;

    my $res = $req->new_response(200);
    $res->content_type("text/plain");
    $res->content("Hello World");

    return $res;
}

1;
