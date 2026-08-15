// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract AUPRegistry {
    struct Agent {
        uint256 id;
        address owner;
        address agentAddress;
        string name;
        string category;
        bool active;
        uint256 registeredAt;
    }

    uint256 private _nextAgentId = 1;

    mapping(uint256 => Agent) public agents;
    mapping(address => uint256[]) private _ownerAgents;

    event AgentRegistered(
        uint256 indexed agentId,
        address indexed owner,
        address indexed agentAddress,
        string name,
        string category
    );

    event AgentStatusUpdated(
        uint256 indexed agentId,
        bool active
    );

    modifier onlyAgentOwner(uint256 agentId) {
        require(
            agents[agentId].owner == msg.sender,
            "AUP: not agent owner"
        );
        _;
    }

    function registerAgent(
        address agentAddress,
        string calldata name,
        string calldata category
    ) external returns (uint256 agentId) {
        require(agentAddress != address(0), "AUP: invalid agent");

        agentId = _nextAgentId++;

        agents[agentId] = Agent({
            id: agentId,
            owner: msg.sender,
            agentAddress: agentAddress,
            name: name,
            category: category,
            active: true,
            registeredAt: block.timestamp
        });

        _ownerAgents[msg.sender].push(agentId);

        emit AgentRegistered(
            agentId,
            msg.sender,
            agentAddress,
            name,
            category
        );
    }

    function setAgentStatus(
        uint256 agentId,
        bool active
    ) external onlyAgentOwner(agentId) {
        require(
            agents[agentId].id != 0,
            "AUP: agent not found"
        );

        agents[agentId].active = active;

        emit AgentStatusUpdated(agentId, active);
    }

    function getAgent(
        uint256 agentId
    ) external view returns (Agent memory) {
        require(
            agents[agentId].id != 0,
            "AUP: agent not found"
        );

        return agents[agentId];
    }

    function getOwnerAgents(
        address owner
    ) external view returns (uint256[] memory) {
        return _ownerAgents[owner];
    }

    function totalAgents() external view returns (uint256) {
        return _nextAgentId - 1;
    }
}