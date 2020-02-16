package Data::Object::Role::Proxyable;

use 5.014;

use strict;
use warnings;
use routines;

use Moo::Role;

# VERSION

# METHODS

method AUTOLOAD() {
  require Carp;

  my ($package, $method) = our $AUTOLOAD =~ m[^(.+)::(.+)$];

  my $build = $package->can('BUILDPROXY');

  my $error = qq(Can't locate object method "$method" via package "$package");

  Carp::confess($error) unless $build && ref($build) eq 'CODE';

  my $proxy = $build->($self, $package, $method, @_);

  Carp::confess($error) unless $proxy && ref($proxy) eq 'CODE';

  goto &$proxy;
}

method BUILDPROXY($package, $method, @args) {
  require Carp;

  my $build = $self->can('build_proxy');

  return $build->($self, $package, $method, @args) if $build;

  Carp::confess(qq(Can't locate object method "build_proxy" via package "$package"));
}

method DESTROY() {

  return;
}

1;
