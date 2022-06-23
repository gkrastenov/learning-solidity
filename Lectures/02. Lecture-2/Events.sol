// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

contract PaymentsStore {
    uint256 public payments;

    function send(address payable _sender) public payable {
        _sender.send(msg.value);
        payments++;
    }

    function transfer(address payable _sender) public payable {
        _sender.transfer(msg.value);
        payments++;
    }
}

contract Receiver {
    event Receive(uint value);

    fallback() external payable {
        emit Receive(msg.value);
    }  
}