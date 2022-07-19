// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

contract Owned {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier OnlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address to) internal OnlyOwner {
        owner = to;
    }
}

library SafeMath {
    function add(address owner, uint256 a, uint256 b) internal pure returns(uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function subtract(address owner, uint256 a, uint256 b) internal pure returns(uint256) {
        assert(b <= a);
        return a - b;
    }

    function multiply(address owner, uint256 a, uint256 b) internal pure returns(uint256) {
        if(a == 0) {
            return 0;
        }

        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }
}

contract Calculator is Owned {
    using SafeMath for address;

    function testCalculator() public view  OnlyOwner {
        assert(5 == owner.add(2, 3));
        assert(17 == owner.subtract(20, 3));
        assert(15 == owner.multiply(5, 3));
    }
}