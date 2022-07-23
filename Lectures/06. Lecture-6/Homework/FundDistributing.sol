// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

 contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: caller is not the owner.");
        _;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address.");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


contract FundDistributing is Ownable {

    event VoteMember(address votedMember);
    event Withdraw(address withdrawAddress, uint amount);

    struct Member {
        address addr;
        uint importancePoints;
    }

    struct Proposal {
        address addr;
        uint amount;
    }

    Proposal proposal;

    mapping(address => uint) members;  // member address => member importance
    mapping(address => bool) isMember; 
    mapping(address => uint) votedFunds;

    bool initilized;
    bool isActiveProposal;

    uint points;
    uint votedPoints;

    constructor() {
        owner = msg.sender;
    }

    modifier isInitilized() {
        require(initilized, "The contract is not initilized.");
        _;
    }

    modifier isNotInitilized() {
        require(!initilized, "The contract already is initilized.");
        _;
    }

    modifier onlyMember {
        require(isMember[msg.sender], "Only member.");
        _;
    }

    modifier activeProposal {
        require(isActiveProposal, "The proposal is not active.");
        _;
    }

    modifier notActiveProposal {
        require(!isActiveProposal, "The proposal is active.");
        _;
    }

    modifier onlyVotedFunds {
        require(votedFunds[msg.sender] > 0);
        _;
    }

    function init(Member[] memory _members) public isNotInitilized {
        require(_members.length >= 3, "Not enough members.");

        uint _points = 0;
        for(uint i = 0; i < _members.length; i++) {
            require(_members[i].addr != owner, "The owner can not be member.");
            require(_members[i].importancePoints < 0, "Can not be added member with negative importance points.");

            members[_members[i].addr] = _members[i].importancePoints;
            isMember[_members[i].addr] = true;
            _points += _members[i].importancePoints;
        }

        points = _points;
        initilized = true;
    }

    function prop(Proposal memory _proposal) public isInitilized onlyOwner notActiveProposal {
        require(_proposal.addr != address(0), "Empty address can not be proposed.");
        require(_proposal.amount > 0, "Amount have to be bigger than zero.");

        proposal = _proposal;
        isActiveProposal = true;
    }

    function vote() public isInitilized onlyMember activeProposal {

        votedPoints += members[msg.sender];
        if(votedPoints >= points / 2){
            votedFunds[proposal.addr] = proposal.amount;
            votedPoints = 0;
        }

        emit VoteMember(msg.sender);
    }

    function withdrawFunds() public onlyVotedFunds {

        uint toBeWithdrawAmaount = votedFunds[msg.sender];
        votedFunds[msg.sender] = 0;

        payable(msg.sender).transfer(toBeWithdrawAmaount);
        
        emit Withdraw(msg.sender, toBeWithdrawAmaount);
    }
}