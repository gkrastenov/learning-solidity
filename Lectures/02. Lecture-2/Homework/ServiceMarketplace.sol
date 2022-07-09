// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;


// Create a contract, that:
// Has a method to buy a certain service, The service costs 1 ETH.
// If the money sent are more than 1ETH, the cntract will return the extra back.
// The contract confirms that the person bought the serivce by emitting an event.
// Nobody can buy the service for 2 minutes after someone bought it. Use a custom function modifier for that.
// Use assert and require whenever possible.
// The onwer of the contract can withdraw the money once per hours and maximum of 5 eth at a time.

contract ServiceMarketplace {
    address public owner;
    uint public lastBuy;
    uint public lastWithdraw;

    event BoughtService(address buyer, uint timestamp);
    event WithdrawAmount(address indexed withdrawal, uint amount);

    constructor () payable {
        lastBuy = block.timestamp - 120;        // initial last buy time 
        lastWithdraw = block.timestamp - 3600;   // initial last withdraw time
        owner = msg.sender;
    }

    modifier hasEnoughMoney {
        require(msg.value >= 1 ether, "Not enough money to buy this service. The service costs 1 ETH.");
        _;
    }

    modifier canBuyService {
        require(lastBuy + 120 <= block.timestamp, "Nobody can buy the service for 2 minutes after someone bought it.");
        _;
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    modifier canWithdraw {
        require(lastWithdraw <= block.timestamp, "The owner of the contract can withdraw the money once per hour.");
        _;
    }

    function buyService() public payable 
        hasEnoughMoney
        canBuyService
    {
        payable(owner).transfer(msg.value);

        if(msg.value > 1 ether){
            payable(msg.sender).transfer(msg.value - 1 ether);

        }

        lastBuy = block.timestamp;
        emit BoughtService(msg.sender, lastBuy;
    }

    function withdraw(uint _amount) public payable
         onlyOwner
         canWithdraw
    {
        require(_amount <= 5 ether, "Maximum withdraw is 5 ETH.");
        require(owner.balance >= _amount, "Not enough money in the balance.");

        payable(owner).transfer(_amount);
        
        lastWithdraw = block.timestamp;

        emit WithdrawAmount(msg.sender, _amount);
    }
}