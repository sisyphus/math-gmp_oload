use strict;
use warnings;
use Test::More;

my ($have_gmp, $have_gmpz, $have_gmpq, $have_mpfr) = (0, 0, 0, 0);
my @haves;

eval{ require Math::GMP;};
if(!$@ && $Math::GMP::VERSION >= 2.11) { $have_gmp = 1 }
else {
  plan skip_all => "SKIPPING: No reliable version of Math::GMP was loaded";
  done_testing();
  exit 0;
}

require Math::GMP_OLOAD;

eval { require Math::GMPz;};
push(@haves, 'Math::GMPz')
  if(!$@ && $Math::GMPz::VERSION >= '0.68');

eval { require Math::GMPq;};
push(@haves, 'Math::GMPq')
  if(!$@ && $Math::GMPq::VERSION >= '0.69');

eval { require Math::MPFR;};
push(@haves, 'Math::MPFR')
  if(!$@ && $Math::MPFR::VERSION >= '4.47');

if(@haves == 0) {
  plan skip_all => "SKIPPING: No suitably recent Math::GMPz, Math::GMPq or Math::MPFR was loaded";
  done_testing();
  exit 0;
}
print "@haves\n";
for my $mod(@haves) {
  warn "Overloading $mod objects with Math::GMP objects\n";
  my $gmp = Math::GMP->new(10);
  my $obj = $mod->new(-5);

  my $new1 = $obj + $gmp; # 5
  my $new2 = $gmp + $obj; # 5
  cmp_ok(ref($new1), 'eq', $mod, "1: correct object returned");
  cmp_ok($new1, '==', 5, "2: correct value returned");
  cmp_ok(ref($new2), 'eq', ref($new1), "3: correct object returned");
  cmp_ok($new2, '==', $new1, "4: correct value returned");
  cmp_ok( ($gmp <=> $new2) * -1, '==', ($new2 <=> $gmp), "4A: consistent <=> comparision");
  cmp_ok( ($gmp < $new2), '==', ($new2 > $gmp), "4B: consistent < comparision");
  cmp_ok( ($gmp <= $new2), '==', ($new2 >= $gmp), "4C: consistent <= comparision");
  cmp_ok( ($gmp > $new2), '==', ($new2 < $gmp), "4D: consistent > comparision");
  cmp_ok( ($gmp >= $new2), '==', ($new2 <= $gmp), "4E: consistent >= comparision");
  cmp_ok( ($gmp == $new2), '==', ($new2 == $gmp), "4F: consistent == comparision");
  cmp_ok( ($gmp != $new2), '==', ($new2 != $gmp), "4G: consistent != comparision");

  $new1 = $obj - $gmp; # -15
  $new2 = $gmp - $obj; # 15
  cmp_ok(ref($new1), 'eq', $mod, "5: correct object returned");
  cmp_ok($new1, '==', -15, "6: correct value returned");
  cmp_ok(ref($new2), 'eq', ref($new1), "7: correct object returned");
  cmp_ok($new2, '==', -$new1, "8: correct value returned");
  cmp_ok( ($gmp <=> $new2) * -1, '==', ($new2 <=> $gmp), "8A: consistent <=> comparision");
  cmp_ok( ($gmp < $new2), '==', ($new2 > $gmp), "8B: consistent < comparision");
  cmp_ok( ($gmp <= $new2), '==', ($new2 >= $gmp), "8C: consistent <= comparision");
  cmp_ok( ($gmp > $new2), '==', ($new2 < $gmp), "8D: consistent > comparision");
  cmp_ok( ($gmp >= $new2), '==', ($new2 <= $gmp), "8E: consistent >= comparision");
  cmp_ok( ($gmp == $new2), '==', ($new2 == $gmp), "8F: consistent == comparision");
  cmp_ok( ($gmp != $new2), '==', ($new2 != $gmp), "8G: consistent != comparision");

  $new1 = $obj * $gmp; # -50
  $new2 = $gmp * $obj; # -50
  cmp_ok(ref($new1), 'eq', $mod, "9: correct object returned");
  cmp_ok($new1, '==', -50, "10: correct value returned");
  cmp_ok(ref($new2), 'eq', ref($new1), "11: correct object returned");
  cmp_ok($new2, '==', $new1, "12: correct value returned");
  cmp_ok( ($gmp <=> $new2) * -1, '==', ($new2 <=> $gmp), "12A: consistent <=> comparision");
  cmp_ok( ($gmp < $new2), '==', ($new2 > $gmp), "12B: consistent < comparision");
  cmp_ok( ($gmp <= $new2), '==', ($new2 >= $gmp), "12C: consistent <= comparision");
  cmp_ok( ($gmp > $new2), '==', ($new2 < $gmp), "12D: consistent > comparision");
  cmp_ok( ($gmp >= $new2), '==', ($new2 <= $gmp), "12E: consistent >= comparision");
  cmp_ok( ($gmp == $new2), '==', ($new2 == $gmp), "12F: consistent == comparision");
  cmp_ok( ($gmp != $new2), '==', ($new2 != $gmp), "12G: consistent != comparision");

  $new1 = $obj / $gmp; # -5 / 10
  $new2 = $gmp / $obj; # 10 / -5
  if($mod eq 'Math::GMPz') {
    cmp_ok(ref($new1), 'eq', $mod, "13: correct object returned");
    cmp_ok($new1, '==', 0, "14: correct value returned");
    cmp_ok(ref($new2), 'eq', ref($new1), "15: correct object returned");
    cmp_ok($new2, '==', -2, "16: correct value returned");
  cmp_ok( ($gmp <=> $new2) * -1, '==', ($new2 <=> $gmp), "16A: consistent <=> comparision");
  cmp_ok( ($gmp < $new2), '==', ($new2 > $gmp), "16B: consistent < comparision");
  cmp_ok( ($gmp <= $new2), '==', ($new2 >= $gmp), "16C: consistent <= comparision");
  cmp_ok( ($gmp > $new2), '==', ($new2 < $gmp), "16D: consistent > comparision");
  cmp_ok( ($gmp >= $new2), '==', ($new2 <= $gmp), "16E: consistent >= comparision");
  cmp_ok( ($gmp == $new2), '==', ($new2 == $gmp), "16F: consistent == comparision");
  cmp_ok( ($gmp != $new2), '==', ($new2 != $gmp), "16G: consistent != comparision");
  }
  else {
    cmp_ok(ref($new1), 'eq', $mod, "13: correct object returned");
    cmp_ok($new1, '==', -0.5, "14: correct value returned");
    cmp_ok(ref($new2), 'eq', ref($new1), "15: correct object returned");
    cmp_ok($new2, '==', 1/$new1, "16: correct value returned");
    cmp_ok( ($gmp <=> $new2) * -1, '==', ($new2 <=> $gmp), "17: consistent <=> comparision");
    cmp_ok( ($gmp < $new2), '==', ($new2 > $gmp), "18: consistent < comparision");
    cmp_ok( ($gmp <= $new2), '==', ($new2 >= $gmp), "19: consistent <= comparision");
    cmp_ok( ($gmp > $new2), '==', ($new2 < $gmp), "20: consistent > comparision");
    cmp_ok( ($gmp >= $new2), '==', ($new2 <= $gmp), "21: consistent >= comparision");
    cmp_ok( ($gmp == $new2), '==', ($new2 == $gmp), "22: consistent == comparision");
    cmp_ok( ($gmp != $new2), '==', ($new2 != $gmp), "23: consistent != comparision");
  }

  if($mod eq 'Math::GMPz') {
    $new1 = $obj ** $gmp;
    cmp_ok(ref($new1), 'eq', $mod, "24: correct object returned");
    cmp_ok($new1, '==', 5 ** 10, "25: correct value returned");

    eval { $new2 = $gmp ** $obj;};
    like($@, qr/Exponent does not fit into unsigned long int in Math::GMPz::overload_pow/, "26: dies as expected");

    $new2 = $gmp ** -$obj;
    cmp_ok(ref($new2), 'eq', $mod, "27: correct object returned");
    cmp_ok($new2, '==', 10 ** 5, "28: correct value returned");

    cmp_ok( ($gmp <=> $new2) * -1, '==', ($new2 <=> $gmp), "29: consistent <=> comparision");
    cmp_ok( ($gmp < $new2), '==', ($new2 > $gmp), "30: consistent < comparision");
    cmp_ok( ($gmp <= $new2), '==', ($new2 >= $gmp), "31: consistent <= comparision");
    cmp_ok( ($gmp > $new2), '==', ($new2 < $gmp), "32: consistent > comparision");
    cmp_ok( ($gmp >= $new2), '==', ($new2 <= $gmp), "33: consistent >= comparision");
    cmp_ok( ($gmp == $new2), '==', ($new2 == $gmp), "34: consistent == comparision");
    cmp_ok( ($gmp != $new2), '==', ($new2 != $gmp), "35: consistent != comparision");
  }

  if($mod eq 'Math::GMPq') {
    $new1 = $obj ** $gmp;
    cmp_ok(ref($new1), 'eq', $mod, "36: correct object returned");
    cmp_ok($new1, '==', 5 ** 10, "37: correct value returned");

    eval { $new2 = $gmp ** $obj;};
    like($@, qr/Raising a value to an mpq_t power is not allowed in '\*\*' operation in Math::GMPq::overload_pow/, "38: dies as expected");

    eval { $new2 = $gmp ** -$obj;};
    like($@, qr/Raising a value to an mpq_t power is not allowed in '\*\*' operation in Math::GMPq::overload_pow/, "39: dies as expected");
  }

  if($mod eq 'Math::MPFR') {
    $gmp -= 8;
    $new1 = $obj ** $gmp; # -5 ** 2
    cmp_ok(ref($new1), 'eq', $mod, "40: correct object returned");
    cmp_ok($new1, '==', 25, "41: correct value returned");

    $new2 = $gmp ** $obj; # 2 ** -5
    cmp_ok(ref($new2), 'eq', $mod, "42: correct object returned");
    cmp_ok($new2, '==', 1 / (2 ** 5), "43: correct value returned");

    cmp_ok( ($gmp <=> $new2) * -1, '==', ($new2 <=> $gmp), "44: consistent <=> comparision");
    cmp_ok( ($gmp < $new2), '==', ($new2 > $gmp), "45: consistent < comparision");
    cmp_ok( ($gmp <= $new2), '==', ($new2 >= $gmp), "46: consistent <= comparision");
    cmp_ok( ($gmp > $new2), '==', ($new2 < $gmp), "47: consistent > comparision");
    cmp_ok( ($gmp >= $new2), '==', ($new2 <= $gmp), "48: consistent >= comparision");
    cmp_ok( ($gmp == $new2), '==', ($new2 == $gmp), "49: consistent == comparision");
    cmp_ok( ($gmp != $new2), '==', ($new2 != $gmp), "50: consistent != comparision");
    $gmp += 8; # Restore to original value.
  }
}

done_testing();
