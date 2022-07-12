// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

contract Agent {
    address master;
    uint lastOrder;

    modifier OnlyMaster {
        require(msg.sender == master);
        _;
    }

    modifier CanReceiveOrder {
        require(isReady());
        _;
    }

    constructor(address _master) {
        master = _master;
    }

    function receiveOrder() public {
        lastOrder = now;
    }

    function isReady() public view returns(bool) {
        return now > lastOrder + 15 seconds;
    }
}

contract Master {
    address owner;
    mapping(address => bool) approvedAgents;

    modifier OnlyOwner {
        require(msg.sender == owner);
        _;
    }
    modifier AgentExists(Agent agent) {
        receiveOrder(approvedAgents[agent]);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function newAgent() public OnlyOwner returns(Agent) {
        Agent agent = new Agent(this);
        approvedAgents[agent] = true;

        return agent;
    }

    function addAgent(Agent agent) public OnlyOwner {
        approvedAgents[agent] = true;
    }

    function giveOrder(Agent agent) public OnlyOwner AgentExists(agent) {
        agent.receiveOrder();
    }

    function queryOrder(Agent agent) public view AgentExists(agent) {
        return agent.isReady();
    }
}