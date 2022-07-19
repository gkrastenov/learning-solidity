// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

library Set {
    struct Data { 
        mapping(uint => bool ) flags;
    }

    // The argument is a storage reference! Yey for low gas expenses!
    // If the function can be seen as a method of that object, you should call the object "self".
    function insert(Data storage self, uint value) public returns (bool) {
        if(self.flags[value])
            return false; // already there
        self.flags[value] = true;
        return true;
    }

    function remove(Data storage self, uint value) public returns (bool) {
        if(!self.flags[value])
            return false; // not there
        self.flags[value] = false;
        return true;
    }

    function contains(Data storage self, uint value) public view returns (bool) {
        return self.flags[value];
    }
}

contract Structure {
    using Set for Set.Data;
    Set.Data knowValues;

    function register(uint value) public {
        // The library function can be called without a 
        // specific instance of the library, since the
        // "instance" will be the current contract.
        require(knowValues.insert(value));
    }

    function testLib() public {
        if(knowValues.contains(42)) {
            knowValues.remove(42);
        }

        assert(knowValues.insert(42));
        assert(knowValues.contains(42));
        assert(knowValues.remove(42));
    }
}