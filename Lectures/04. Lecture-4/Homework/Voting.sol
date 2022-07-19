// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

/*
Create a contract that:
1. Is Owned
2. Can be killed
3. Uses safe math operations
4. Has members(people that are member ot the contract)
5. The owner is the first member
6. The owner can remove members
7. To add a new member, there need to be a voting
    if > 50% of the members agree, the new member is added
8. For each member we hold:
    His address
    ETH donated to the contract
    Timestamp of last donation
9. A member can be remvoed from the contract if he has not donated tot he contract in the last 1 hour
10. Use a library for all member related actions
*/

// TODO: add events
// TODO: test contract
// TODO: add safemath 
contract Ownable {
    address owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}

contract Destructible is Ownable {

    function destroy() onlyOwner public payable {
        selfdestruct(payable (owner));
    }

    function destroyAndSend(address _recipient) onlyOwner public payable {
        selfdestruct(payable (_recipient));
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns(uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns(uint256) {
        assert(b <= a);
        return a - b;
    }

    function div(uint256 a, uint256 b) internal pure returns(uint256) {
        // there is no case where this function can overflow/underflow
        uint c = a / b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns(uint256) {
        if(a == 0) {
            return 0;
        }

        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }
}

library MemberLib {
    using SafeMath for uint;

    struct Member {
        address addr;
        uint donatedETH;
        uint timestamp;
        uint lastDonation; // value of last ETH donation
    }

    modifier onlyMembers(Data storage data) {
        require(data.members[msg.sender].addr == msg.sender);
        _;
    }

    struct Data {
        uint membersCount;

        mapping(address => Member) members;
        mapping(address => Member) waitingMembers;
        mapping(address => uint) memberVotes;
    }

    function removeMember(Data storage data, address addr) public  onlyMembers(data) {
        require(data.members[addr].addr != address(0) , "Does not exists!");

        if(data.members[addr].lastDonation + 1 hours < block.timestamp){
            delete data.members[addr];
            data.membersCount--;
        }    
    }

    function addMember(Data storage data, address addr) public {
        require(data.members[addr].addr == address(0), "Already exists!");

        data.waitingMembers[addr] = Member(addr, msg.value, block.timestamp, block.timestamp);
        data.memberVotes[addr] = 0; 
    }

    function initilize(Data storage data, address addr) public {
        data.members[addr] = Member(addr, msg.value, block.timestamp, block.timestamp);
        data.membersCount = 1;
    }

    function voteForMember(Data storage data, address memberAddress) public onlyMembers(data) {
        require(data.waitingMembers[memberAddress].addr != address(0) , "Does not exists!");

        data.memberVotes[memberAddress]++;
        if(data.memberVotes[memberAddress] > data.membersCount / 2){
            data.members[memberAddress] = data.waitingMembers[memberAddress];
            delete data.waitingMembers[memberAddress];
            data.memberVotes[memberAddress] = 0;
        }
    }

    function containsMember(Data storage data, address memberAddress) public view
        returns (address addr, uint donatedETH,uint timestamp, uint lastDonation) 
    {
        return (data.members[memberAddress].addr, data.members[memberAddress].donatedETH, data.members[memberAddress].timestamp, data.members[memberAddress].lastDonation);
    }
        
}

contract Voting is Destructible{

    using MemberLib for MemberLib.Data;
    MemberLib.Data membership;

    constructor () {
        membership.initilize(owner);
    }

    function add(address addr) public {
        membership.addMember(addr);
    }

    function remove(address addr) public onlyOwner {
        membership.removeMember(addr);
    }

    function vote(address addr) public {
        membership.voteForMember(addr);
    }

    function contains(address addr) public view
     returns (address adr, uint donatedETH,uint timestamp, uint lastDonation) {
        
        return membership.containsMember(addr);
    }
}