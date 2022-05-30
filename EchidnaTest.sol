// SPDX-License-Identifier: BSD-4-Clause
pragma solidity ^0.8.1;

import "ABDKMath64x64.sol";

contract Test {
    int128 internal zero = ABDKMath64x64.fromInt(0);
    int128 internal one = ABDKMath64x64.fromInt(1);
    int128 private constant MIN_64x64 = -0x80000000000000000000000000000000;
    int128 private constant MAX_64x64 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

    event Value(string, int64);

    function debug(string calldata x, int128 y) public {
        emit Value(x, ABDKMath64x64.toInt(y));
    }

    function add(int128 x, int128 y) public returns (int128) {
        return ABDKMath64x64.add(x, y);
    }

    function sub(int128 x, int128 y) public returns (int128) {
        return ABDKMath64x64.sub(x, y);
    }

    function mul(int128 x, int128 y) public returns (int128) {
        return ABDKMath64x64.mul(x, y);
    }

    function muli(int128 x, int256 y) public returns (int256) {
        return ABDKMath64x64.muli(x, y);
    }

    function mulu(int128 x, uint256 y) public returns (uint256) {
        return ABDKMath64x64.mulu(x, y);
    }

    function div(int128 x, int128 y) public returns (int128) {
        return ABDKMath64x64.div(x, y);
    }

    function divi(int256 x, int256 y) public returns (int128) {
        return ABDKMath64x64.divi(x, y);
    }

    function divu(uint256 x, uint256 y) public returns (int128) {
        return ABDKMath64x64.divu(x, y);
    }

    function fromInt(int256 x) public returns (int128) {
        return ABDKMath64x64.fromInt(x);
    }

    function toInt(int128 x) public returns (int64) {
        return ABDKMath64x64.toInt(x);
    }

    function fromUInt(uint256 x) public returns (int128) {
        return ABDKMath64x64.fromUInt(x);
    }

    function toUInt(int128 x) public returns (uint256) {
        return ABDKMath64x64.toUInt(x);
    }

    function from128x128(int256 x) public returns (int128) {
        return ABDKMath64x64.from128x128(x);
    }

    function to128x128(int128 x) public returns (int256) {
        return ABDKMath64x64.to128x128(x);
    }

    function pow(int128 x, uint256 y) public returns (int128) {
        return ABDKMath64x64.pow(x, y);
    }

    function neg(int128 x) public returns (int128) {
        return ABDKMath64x64.neg(x);
    }

    function abs(int128 x) public returns (int128) {
        return ABDKMath64x64.abs(x);
    }

    function inv(int128 x) public returns (int128) {
        return ABDKMath64x64.inv(x);
    }

    function avg(int128 x, int128 y) public returns (int128) {
        return ABDKMath64x64.avg(x, y);
    }

    function sqrt(int128 x) public returns (int128) {
        return ABDKMath64x64.sqrt(x);
    }

    function log_2(int128 x) public returns (int128) {
        return ABDKMath64x64.log_2(x);
    }

    function ln(int128 x) internal pure returns (int128) {
        return ABDKMath64x64.ln(x);
    }

    // gavg
    // exp
    // exp2

    function testAdd(
        int128 x,
        int128 y,
        int128 z,
        int128 a
    ) public {
        z = add(x, y);
        if (x == zero && y == zero) {
            assert(z == 0);
        }
        if (x == zero) {
            assert(z == y);
        }

        if (y == zero) {
            assert(z == x);
        }

        if (x > zero && y > zero) {
            assert(z > x && z > y);
        }

        if (x > zero && y < zero) {
            assert(z < x && z > y);
        }

        if (x < zero && y > zero) {
            assert(z > x && z < y);
        }

        if (x < zero && y < zero) {
            assert(z < x && z < y);
        }

        assert(z >= MIN_64x64 && z <= MAX_64x64);

        assert(z == add(y, x));

        assert(add(zero, x) == x);

        assert(add(add(x, y), a) == add(x, add(y, a)));
    }

    function testAddOverflow(int128 x, int128 y) public {
        bool willOverflow = false;
        require(willOverflow);
        try (this).add(x, y) returns (int128 z) {} catch {
            assert(false);
            willOverflow = true;
        }
    }

    function testSub(
        int128 x,
        int128 y,
        int128 z
    ) public {
        z = sub(x, y);
        if (x == zero && y == zero) {
            assert(z == 0);
        }
        if (x == zero) {
            assert(z == -(y));
        }

        if (y == zero) {
            assert(z == (x));
        }

        if (x == y) {
            assert(z == 0);
        }

        if (x > zero && y > zero && x > y) {
            assert(z < x);
        }

        if (x > zero && y > zero && x < y) {
            assert(z <= x && z < y);
        }

        if (x > zero && y < zero) {
            assert(z > x && z > y);
        }

        if (x < zero && y > zero) {
            assert(z < x && z < y);
        }

        if (x < zero && y < zero && x > y) {
            assert(z >= x && z > y);
        }

        if (x < zero && y < zero && x < y) {
            assert(z > x);
        }

        assert(z >= MIN_64x64 && z <= MAX_64x64);

        assert(neg(z) == sub(y, x));

        assert(sub(zero, x) == neg(x));
    }

    // (xy)z = x(yz) not working
    function testMul(
        int128 x,
        int128 y,
        int128 z
    ) public {
        int128 ans = mul(x, y);
        assert(ans >= MIN_64x64 && ans <= MAX_64x64);

        assert((ans) == mul(y, x));

        assert(mul(one, x) == (x));

        assert(mul(mul(x, y), z) >= mul(x, mul(y, z)));
    }

    function testMuli(
        int128 x,
        int128 y,
        int128 z
    ) public {
        int256 ans = muli(x, y);

        assert((ans) == muli(y, x));

        assert(muli(one, y) == (y));

        assert(
            muli(from128x128(muli(x, y)), z) ==
                muli(x, (muli(from128x128(y), z)))
        );
    }

    function testMulu(
        int128 x,
        uint256 y,
        uint256 z
    ) public {
        uint256 ans = mulu(x, (y));

        assert((ans) == mulu(fromUInt(y), toUInt(x)));

        assert(mulu(one, y) == (y));

        assert(
            mulu(fromUInt(mulu(x, y)), z) == mulu(x, (mulu(fromUInt(y), z)))
        );
    }

    function testDiv(int128 x, int128 y) public {
        if (y != zero) {
            try this.div(x, y) returns (int128 z) {
                assert(div(x, one) == x);
                assert(div(x, x) == one);
            } catch {
                assert(false);
            }
        }

        if (x != zero) {
            try this.div(zero, x) returns (int128 z) {
                assert(z == zero);
            } catch {
                assert(false);
            }
        }
    }

    function testDivi(int256 x, int256 y) public {
        int128 xc;
        if (x >= 0) {
            xc = from128x128(x);
        } else {
            xc = -from128x128(-(x));
        }
        assert(divi(x, to128x128(one)) == (xc));
        assert(divi(x, x) == one);
        if (x != zero) {
            try this.divi(to128x128(zero), x) returns (int128 z) {
                assert(z == zero);
            } catch {
                assert(false);
            }
        }
    }

    function testDivu(uint256 x, uint256 y) public {
        assert(divu(x, 1) == fromUInt(x));
        assert(divu(x, x) == one);
        if (x != 0) {
            try this.divu(0, x) returns (int128 z) {
                assert(z == zero);
            } catch {
                assert(false);
            }
        }
    }

    function testNeg(int128 x) public {
        try this.neg(x) returns (int128 ans) {
            assert(neg(x) == ans);
            assert(mul(ans, neg(one)) == x);
            assert(add(x, ans) == zero);
        } catch {
            assert(false);
        }
    }

    function testAbs(int128 x) public {
        if (x >= zero) {
            try this.abs(x) returns (int128 ans) {
                assert(x == ans);
            } catch {
                assert(false);
            }
        } else {
            try this.abs(x) returns (int128 ans) {
                assert(x == neg(ans));
            } catch {
                assert(false);
            }
        }
    }

    // 1 -- case
    function testInv(int128 x) public {
        if (x != zero) {
            try this.inv(x) returns (int128 ans) {
                assert(ans >= MIN_64x64 && ans <= MAX_64x64);
                assert(ans == div(one, x));
            } catch {
                assert(false);
            }
        }
    }

    function testPow(
        int128 x,
        int128 y,
        uint256 a,
        uint256 b
    ) public {
        assert(pow(x, 0) == one);
        assert(pow(x, toUInt(neg(fromUInt(a)))) == pow(inv(x), a));

        assert(pow(x, a + b) == mul(pow(x, a), pow(x, b)));
        assert(pow(x, a - b) == div(pow(x, a), pow(x, b)));

        assert(pow(pow(x, a), b) == pow(x, a * b));

        assert(pow(mul(x, y), a) == mul(pow(x, a), pow(y, a)));

        assert(pow(div(x, y), a) == div(pow(x, a), pow(y, a)));
    }

    function testAvg(int128 x, int128 y) public {
        if (x >= 0 && y >= 0) {
            try this.avg(x, y) returns (int128 ans) {
                assert(div(add(x, y), fromInt(2)) == avg(x, y));
                assert(div(add(x, y), fromInt(2)) == avg(y, x));
            } catch {
                assert(false);
            }
        } else {
            try this.avg(x, y) returns (int128 ans) {
                assert(div(add(x, y), fromInt(2)) >= avg(x, y));
                assert(div(add(x, y), fromInt(2)) >= avg(y, x));
            } catch {
                assert(false);
            }
        }
    }

    function testSqrt(int128 x, int128 y) public {
        int128 ans = sqrt(x);
        int128 diff = sub(x, mul(ans, ans));
        assert(add(diff, mul(ans, ans)) == x);

        int128 diff2 = sub(x, pow(ans, 2));
        assert(add(diff2, pow(ans, 2)) == x);

        assert(sqrt(mul(x, y)) == mul(sqrt(x), sqrt(y)));

        assert(sqrt(div(x, y)) == div(sqrt(x), sqrt(y)));
    }

    function testLog2(
        int128 x,
        int128 y,
        int128 b,
        int128 k
    ) public {
        assert(log_2(one) == zero);
        assert(log_2(fromUInt(2)) == one);

        assert(log_2(mul(x, y)) == add(log_2(x), log_2(y)));
        assert(log_2(div(x, y)) == sub(log_2(x), log_2(y)));

        assert(log_2(pow(x, toUInt(k))) == mul(k, log_2(x)));
        assert(log_2(pow(fromUInt(2), toUInt(k))) == k);
    }

    function testLn(
        int128 x,
        int128 y,
        int128 b,
        int128 k
    ) public {
        assert(ln(one) == zero);
        assert(ln(fromInt(2)) == one);

        assert(ln(mul(x, y)) == add(ln(x), ln(y)));
        assert(ln(div(x, y)) == sub(ln(x), ln(y)));

        assert(ln(pow(x, toUInt(k))) == mul(k, ln(x)));
        assert(ln(pow(fromUInt(2), toUInt(k))) == k);
    }
}
