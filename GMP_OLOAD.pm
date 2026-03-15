use strict;
use warnings;
{
  package Math::GMP_OLOAD;
  BEGIN {
    eval{ require Math::GMP;};
    if($@) {
      die "Math::GMP_OLOAD failed to load Math::GMP:\n$@";
    }
  }

  $Math::GMP_OLOAD::VERSION = '0.01';
}

{
  package Math::GMP;

    use overload "+" => sub ($$$) {
      my($x, $y) = (shift, shift);
      if(ref($y) eq 'Math::MPFR' || ref($y) eq 'Math::GMPq') {
        return $y + $x;
      }

      return Math::GMP::op_add($x, $y, 0);
    };

    use overload "-" => sub ($$$)  {
      my($x, $y) = (shift, shift);
      if(ref($y) eq 'Math::MPFR' || ref($y) eq 'Math::GMPq') {
        return -($y - $x);
      }

      return Math::GMP::op_sub($x, $y, shift);
    };

    use overload "*" => sub ($$$) {
      my($x, $y) = (shift, shift);
      if(ref($y) eq 'Math::MPFR' || ref($y) eq 'Math::GMPq') {
        return $y * $x;
      }

      return Math::GMP::op_mul($x, $y, 0);
    };

    use overload "/" => sub ($$$) {
      my($x, $y) = (shift, shift);
      if(ref($y) eq 'Math::MPFR' || ref($y) eq 'Math::GMPq') {
        return 1/($y / $x);
      }

      return Math::GMP::op_div($x, $y, shift);
    };

    use overload "**" => sub {
      my($x, $y) = (shift, shift);
      if(ref($y) eq 'Math::MPFR') {
        return Math::MPFR::overload_pow($y, $x, 1);
      }
      elsif(ref($y) eq 'Math::GMPq') {
        # Currently: Invalid argument supplied to Math::GMPq::overload_pow
        return Math::GMPq::overload_pow($y, $x, 1);
      }

      my $s = shift;
      return $s ? op_pow($y, $x) : op_pow($x, $y);
    };


    use overload "<" => sub  {
      my($x, $y) = (shift, shift);
      if(ref($y) eq 'Math::MPFR' || ref($y) eq 'Math::GMPq') {
        return 1 if $y > $x;
        return 0;
      }

      my $cmp = Math::GMP::op_spaceship($x, $y, shift);
      return 1 if $cmp < 0;
      return 0;
    };

    use overload ">" => sub  {
      my($x, $y) = (shift, shift);
      if(ref($y) eq 'Math::MPFR' || ref($y) eq 'Math::GMPq') {
        return 1 if $y < $x;
        return 0;
      }

      my $cmp = Math::GMP::op_spaceship($x, $y, shift);
      return 1 if $cmp > 0;
      return 0;
    };

    use overload "<=" => sub  {
      my($x, $y) = (shift, shift);
      if(ref($y) eq 'Math::MPFR' || ref($y) eq 'Math::GMPq') {
        return 1 if $y >= $x;
        return 0;
      }

      my $cmp = Math::GMP::op_spaceship($x, $y, shift);
      return 1 if $cmp <= 0;
      return 0;
    };

    use overload ">=" => sub  {
      my($x, $y) = (shift, shift);
      if(ref($y) eq 'Math::MPFR' || ref($y) eq 'Math::GMPq') {
        return 1 if $y <= $x;
        return 0;
      }

      my $cmp = Math::GMP::op_spaceship($x, $y, shift);
      return 1 if $cmp >= 0;
      return 0;
    };

    use overload "==" => sub ($$$)  {
      my($x, $y) = (shift, shift);
      if(ref($y) eq 'Math::MPFR' || ref($y) eq 'Math::GMPq') {
        return 1 if $y == $x;
        return 0;
      }

      my $cmp = Math::GMP::op_spaceship($x, $y, 0);
      return 1 if $cmp == 0;
      return 0;
    };

    use overload "!=" => sub ($$$)  {
      my($x, $y) = (shift, shift);
      if(ref($y) eq 'Math::MPFR' || ref($y) eq 'Math::GMPq') {
        return 1 if $y != $x;
        return 0;
      }

      my $cmp = Math::GMP::op_spaceship($x, $y, 0);
      return 1 if $cmp != 0;
      return 0;
    };

    use overload "<=>" => sub ($$$)  {
      my($x, $y) = (shift, shift);
      if(ref($y) eq 'Math::MPFR' || ref($y) eq 'Math::GMPq') {
        return ($y <=> $x) * -1;
      }

      my $cmp = Math::GMP::op_spaceship($x, $y, shift);
      return $cmp;
    };
}

1;
