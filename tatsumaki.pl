package MyApp::Handler::Hello;
use base qw(Tatsumaki::Handler);

sub get {
    my $self = shift;
    $self->response->content_type('text/plain');
    $self->write("Hello World");
}

package MyApp::Handler::BlogMonthly;
use base qw(Tatsumaki::Handler);

sub get {
    my($self, $month, $year) = @_;
    my $p = $self->request->parameters;
    $self->write("Blog posts from $month/$year");
}

package MyApp::Handler::Comment;
use base qw(Tatsumaki::Handler);

sub post {
    my $self = shift;
    $self->write("Posted new comment with body=" . $self->request->parameters->{body});
}

package main;
use Tatsumaki::Application;

Tatsumaki::Application->new([
    '/blog/(\d{4})/(\d{2})' => 'MyApp::Handler::BlogMonthly',
    '/comment' => 'MyApp::Handler::Comment',
    qr'^/$' => 'MyApp::Handler::Hello',
])->psgi_app;


