use strict;
use warnings;

use Test::More;

eval { require Math::GMP_OLOAD;};

if(!$@) { pass("Math::GMP_OLOAD loaded") }
else {
  like($@, qr/^Math::GMP_OLOAD failed to load Math::GMP/, "Math::GMP_OLOAD failed to load as expected");
}

done_testing();
