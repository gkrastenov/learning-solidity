// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

contract Owned {
    address owner;

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

contract SafeMath {
    function add(uint256 a, uint256 b) internal pure returns(uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function subtract(uint256 a, uint256 b) internal pure returns(uint256) {
        assert(b <= a);
        return a - b;
    }

    function multiply(uint256 a, uint256 b) internal pure returns(uint256) {
        if(a == 0) {
            return 0;
        }

        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }
}

contract Calculator is Owned, SafeMath {
    uint256 public number;
    uint256 lastChange;

    constructor () {
        lastChange = block.timestamp;
    }

    function changeNumber() public OnlyOwner {
        number = add(number, block.timestamp % 256);
        number = multiply(number, subtract(block.timestamp, lastChange));
        number = subtract(number, block.gaslimit);

        lastChange = block.timestamp;
    }
}