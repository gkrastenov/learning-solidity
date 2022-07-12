// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

contract SomeContract {
    event callMeMaybeEvent(address _from);
    function callMeMaybe() payable public {
        emit callMeMaybeEvent(this);
    }
}

contract ThatCallsSomeContract {
    function callTheOtherContract(address _contractAddress) public {
        // it will try to call function callMeMaybe by take first 4 byte after hashish of function.
        // It will return true if function exists, otherwise false

        // it will be excecuted from the context of SomeContract
        require(_contractAddress.call(byte4(keccak256("callMeMaybe"))));

        // it will be excecuted from the context of ThatCallsSomeContract
        require(_contractAddress.delegatecall(byte4(keccak256("callMeMaybe"))));
    }
}