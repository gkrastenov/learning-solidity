// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

contract MathHelper {
    function add(uint a, uint b) pure public returns(uint) {
        return a + b;
    }
}

contract MathUser {
    MathHelper public mathHelper;
    uint public lastRes;

    constructor() public {
        math = new MathHelper();
    }

    function calculate(uint n, uint m) public {
        lastRes = math.add(n, m);
    }

    function temporaryContract(address mathHelper) public {
        lastRes = MathHelper(mathHelper).add(7, 8);
    }
}