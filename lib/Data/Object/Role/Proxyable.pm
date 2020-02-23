package Data::Object::Role::Proxyable;

use 5.014;

use strict;
use warnings;

use Moo::Role;

# VERSION

# METHODS

sub AUTOLOAD {
  require Carp;

  my ($package, $method) = our $AUTOLOAD =~ m[^(.+)::(.+)$];

  my $build = $package->can('BUILDPROXY');

  my $error = qq(Can't locate object method "$method" via package "$package");

  Carp::confess($error) unless $build && ref($build) eq 'CODE';

  my $proxy = $build->($package, $method, @_);

  Carp::confess($error) unless $proxy && ref($proxy) eq 'CODE';

  goto &$proxy;
}

sub BUILDPROXY {
  my ($package, $method, $self, @args) = @_;

  require Carp;

  my $build = $self->can('build_proxy');

  return $build->($self, $package, $method, @args) if $build;

  Carp::confess(qq(Can't locate object method "build_proxy" via package "$package"));
}

sub DESTROY {

  return;
}

1;
