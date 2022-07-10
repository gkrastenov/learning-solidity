// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

contract StateContract {
    enum States { Locked, Unlocked, Restricted }

    address owner;
    States state;

    struct ContractStructure {
        address addr;
        uint counter;
        uint timestamp;
    }

    ContractStructure structure;

    event ChangeState(address indexed, uint timestamp);

    constructor() {
        owner = msg.sender;
        structure = ContractStructure(address(0), 0, 0);

    }

    fallback () external payable IsLocked {
        
    }

    modifier IsLocked{
        require(state == States.Locked);
        require(msg.sender == owner);
        _;
    }

    modifier IsUnlocked{
        require(state == States.Unlocked);
        _;
    }

    modifier IsRestricted{
        require(state == States.Restricted);
        _;
    }

    function changeState(uint _newState) public 
        IsLocked
    {
        state = States(_newState);

        emit ChangeState(msg.sender, block.timestamp);
    }

    function changeContractStructure() public 
        IsRestricted       
    {
        structure.addr = msg.sender;
        structure.counter += 1;
        structure.timestamp = block.timestamp;
    }
}