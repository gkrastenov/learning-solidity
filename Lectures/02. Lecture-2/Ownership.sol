// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

contract Ownership {
    address public owner;
    address proposedOwner;
    uint timeLimit;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event OwnershipAccepted(address indexed newOwner);

    event SentEther(address sender, uint sentValue);

    constructor() {
        owner = msg.sender;
    }

    fallback () external payable {
        emit SentEther(msg.sender, msg.value);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "This can only be called by the contract owner!");
        _;
    }

    modifier onlyProposedOwner {
        require(msg.sender == proposedOwner, "This can only be called by the proposed owner!");
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {

        emit OwnershipTransferred(msg.sender, _newOwner);
        proposedOwner = _newOwner;
        timeLimit = block.timestamp;
    }

    function acceptOwnership() public onlyProposedOwner {
        require(block.timestamp < timeLimit + 30);

        emit OwnershipAccepted(msg.sender);
        owner = msg.sender;
    }
}