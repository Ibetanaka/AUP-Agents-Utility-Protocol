// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract AUPRegistry {
    struct Agent {
        string name;
        address owner;
        bool active;
    }

    uint256 public agentCount;
    mapping(uint256 => Agent) public agents;

    function registerAgent(string memory name) external {
        agentCount++;

        agents[agentCount] = Agent({
            name: name,
            owner: msg.sender,
            active: true
        });
    }

    function deactivateAgent(uint256 agentId) external {
        require(
            agents[agentId].owner == msg.sender,
            "Not owner"
        );

        agents[agentId].active = false;
    }
}