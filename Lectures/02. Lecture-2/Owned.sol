// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

contract Owned {

    uint state;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "This can only be called by the contract owner!");
        _;
    }

    function kill() public onlyOwner {
        selfdestruct(owner);
    }

    function setNewState(uint _state) public onlyOwner {
        state = _state;
    }

    function getOwnerBalance() public view returs(uint256) {
        return owner.balance;
    }
}