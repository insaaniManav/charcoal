package Charcoal::Controller::Admin::Destinations;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Charcoal::Controller::Admin::Destinations - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base :Chained('/') :PathPart('admin/destinations') :CaptureArgs(0) {}

sub list :Chained('base') :PathPart('list') :Args(0) {
    my ( $self, $c ) = @_;

	my $page = $c->request->params->{page};
	$page = 1 if ( ( $page !~ /^\d+$/ ) or (!$page) );
	
	my $destinations = $c->model('PgDB::CDomain')->search({ 
						customer => $c->user->customer->id,
						},
						{
							page	=> $page,
							rows	=> 10,
							order_by => { -asc => 'domain' }
						},
						);
						
	$c->stash->{destinations} 	= 	[ $destinations->all ];
	$c->stash->{pager}			=	$destinations->pager;
	$c->stash->{template} 		= 	'destinations.tt2';
	
    $c->forward( $c->view() );
   
   # $c->response->body('Matched Charcoal::Controller::Admin::Destinations in Admin::Destinations.');
}



=encoding utf8

=head1 AUTHOR

Unmukti Technology Pvt Ltd,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
