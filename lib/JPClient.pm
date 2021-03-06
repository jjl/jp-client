package JPClient;

# $Id:$

use JPClient::API;
use RPC::XML::Client ();

has hostname => (
    isa     => 'Str',
    is      => 'rw',
    default => 'localhost',
);

has port => (
    isa     => 'Int',
    is      => 'rw',
    default => 3000,
);

has defaultparams => (
    isa     => 'ArrayRef[Str]',
    is      => 'rw',
    default => sub {
        return [];
    },
);

has beforesend => (
    isa     => 'CodeRef',
    is      => 'ro',
    default => sub {
        sub {
            my ( $self, $sys, $params ) = @_;
            return $params;
          }
    }
);

has postreceive => (
    isa     => 'CodeRef',
    is      => 'ro',
    default => sub {
        sub {
            my ( $self, $sys, $result ) = @_;
            return $result;
          }
    }
);

has path => (
    isa     => 'Str',
    is      => 'rw',
    default => 'api/xmlrpc/',
);

has _prefix => (
    isa      => 'Str',
    is       => 'rw',
    required => 0,
    default  => '',
);

has _connector => (
    isa        => 'RPC::XML::Client',
    is         => 'rw',
    lazy_build => 1,
);

has _sys => (
    isa        => __PACKAGE__,
    is         => 'rw',
    lazy_build => 1,
);

dynamic_call 'test';
child_namespace 'account';
child_namespace 'info';
child_namespace 'recruiter';
child_namespace 'candidate';

sub _build__connector {
    my $self = shift;
    return RPC::XML::Client->new(
        sprintf( 'http://%s:%s/%s', $self->hostname, $self->port, $self->path )
    );
}

sub _build__sys {
    return shift;
}

freeze();
1;

__END__

=head1 Name

JPClient

=head1 Description

An RPC Client for JobPractical

=head1 Synopsis

    use JPClient;
    my $jc = JPClient->new( apikey => 'key' );
    $jc->account->login({
        email => foo@bar.org,
        @morestuff,
        persist_login => 1,
    });
    $jc->info->whatever;
    $jc->account->logout();

=head1 Methods

=over 4

=item ->account   L<JPClient::Account>

=over 8

=item ->account->login L<JPClient::Account/login>

=item ->account->logout L<JPClient::Account/logout>

=back

=item ->info      L<JPClient::Info>

=item ->recruiter L<JPClient::Recruiter>

=item ->candidate L<JPClient::Candidate>

=back

=head1 Author

Kent Fredric

=head1 Copyright

=head1 License

=cut

1;
