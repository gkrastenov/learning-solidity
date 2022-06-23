// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

contract Auction {
    address public owner;
    uint public startBlock;
    uint public endBlock;

    bool public canceled;
    address public highestBidder;
    mapping(address => uint256) public foundsByBidder;

    event LogBid(address bidder, uint bid, address highestBidedr, uint highestBid);
    event LogWithdrawl(address withdrawer, address withdrawerAccount,  uint amount);
    event LogCanceled();

    constructor (uint _startBlock, uint _endBlock) public {
        require(_startBlock < _endBlock);
        require(_startBlock > block.number);

        owner = msg.sender;
        startBlock = _startBlock;
        endBlock = _endBlock;
    }

    modifier onlyNotOwner {
        require(msg.sender != owner);
        _;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier activeAuction {
        require(canceled == false);
        require(startBlock < block.number && block.number < endBlock);
        _;
    }

    modifier onlyAfterStart {
        require(block.number > startBlock);
        _;
    }

    modifier onlyBeforeStart {
        require(block.number < endBlock);
        _;
    }

     modifier onlyNotCancel {
        require(canceled == false);
        _;
    }

    modifier onlyEndedOrCanceled {
        require(block.number > endBlock || canceled == true);
        _;
    }

    function placeBid() public payable 
         onlyAfterStart 
         onlyBeforeStart 
         onlyNotCancel
         onlyOwner 
    {
        // reject payments of 0 ETH
        require(msg.value > 0);

        uint newBid = foundsByBidder[msg.sender] + msg.value;
        uint currentHighestBid = foundsByBidder[highestBidder];

        // if the user is not even willing to overbide the highest bid, there is nothing for us
        // to do except revert the transaction.
        require(newBid > currentHighestBid);

        // update the user bid
        foundsByBidder[msg.sender] = newBid;
        highestBidder = msg.sender;

        emit LogBid(msg.sender, newBid, highestBidder, currentHighestBid);
    }

    function withdraw() public payable 
         onlyEndedOrCanceled
     {
         address withdrawalAccount;
         uint withdrawalAmmount;

         if(canceled) {
             // if the auction was canceled, everyone should simply be allowed to withdraw their fund.
             withdrawalAmmount = foundsByBidder[msg.sender];
         } else {
             // highest bidder won the auction, so he can not withdraw his money.
             require(msg.sender != highestBidder);
            
             // the auciton finished without being canceled            
             if(msg.sender == owner) {
                // the auction owner should be allowed to withdraw the highestBid
                withdrawalAmmount = foundsByBidder[highestBidder];
            } else {
                // anyone who participated but did not win the auction
                // should be allowed to withdraw
                // the full amout of their funds.               
                withdrawalAmmount = foundsByBidder[msg.sender];
            }
         }
         
         require(withdrawalAmmount > 0);

         foundsByBidder[withdrawalAccount] -= withdrawalAmmount;

         // send the fuds
         payable(msg.sender).transfer(withdrawalAmmount);

         emit LogWithdrawl(msg.sender, withdrawalAccount, withdrawalAmmount);
        
    }

    function cancelAuction() public
        onlyAfterStart
        onlyBeforeStart
        onlyOwner      
    {
        canceled = true;
        emit LogCanceled();
    }

    // Check the highest bid and the highest bidder
    function checkHighestBidder() public view returns(address, uint256) {
        return (highestBidder, foundsByBidder[highestBidder]);
    }
}