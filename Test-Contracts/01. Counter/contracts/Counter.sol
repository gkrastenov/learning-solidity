// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;
 
contract Ownable {
    address public owner;
    
    event OwnershipTransferred(address indexed previonpusOwner, address indexed newOwner);
    
    modifier onlyOwner() {
        require(msg.sender == owner, 'Only owner');
        _;
    }
    
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));

        owner = newOwner;
        emit OwnershipTransferred(owner, newOwner);
    }
}
 
contract Counter is Ownable {
    uint public times;
    uint public value;
    
    constructor () {
        owner = msg.sender;
        times = 0;
        value = 0;
    }

    function increment(uint _value) public onlyOwner {
        value+= _value;
        times++;
    }
}