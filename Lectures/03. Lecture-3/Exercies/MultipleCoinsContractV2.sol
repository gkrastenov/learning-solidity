// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

contract MultipleCoinsContract {

    enum Coins { RedCoins, BlueCoins, GreenCoins, YellowCoins, PurpleCoins, BlackCoins}

    mapping(address => mapping(Coins => uint256)) balance;

    constructor() public {
        balance[msg.sender][Coins.RedCoins] = 10000;
        balance[msg.sender][Coins.BlueCoins] = 10000;
        balance[msg.sender][Coins.GreenCoins] = 10000;
        balance[msg.sender][Coins.YellowCoins] = 10000;
        balance[msg.sender][Coins.PurpleCoins] = 10000;
        balance[msg.sender][Coins.BlackCoins] = 10000;
    }

    function sendRedCoins(address _to, Coins _coin, uint256 _amount) public {
        require(balance[msg.sender][_coin] >= _amount);

        balance[msg.sender][_coin] -= _amount;
        balance[_to][_coin] += _amount;
    }  
}