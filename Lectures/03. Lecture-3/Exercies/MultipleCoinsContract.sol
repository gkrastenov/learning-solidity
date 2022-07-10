// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

contract MultipleCoinsContract {

    struct MultipleCoins {
        uint256 RedCoins;
        uint256 GreenCoins;
    }

    mapping(address => MultipleCoins) balance;

    constructor() public {
        balance[msg.sender].RedCoins = 10000;
        balance[msg.sender].GreenCoins = 5000;
    }

    function sendRedCoins(address _to, uint256 _amount) public {
        require(balance[msg.sender].RedCoins >= _amount);

        balance[msg.sender].RedCoins -= _amount;
        balance[_to].RedCoins += _amount;
    }

    function sendGreenCoins(address _to, uint256 _amount) public {
        require(balance[msg.sender].GreenCoins >= _amount);

        balance[msg.sender].GreenCoins -= _amount;
        balance[_to].GreenCoins += _amount;
    }
}