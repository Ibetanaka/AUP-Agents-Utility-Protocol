// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../contracts/AUPRegistry.sol";

contract AUPRegistryTest is Test {
    AUPRegistry registry;

    function setUp() public {
        registry = new AUPRegistry();
    }

    function testRegisterAgent() public {
        registry.registerAgent("Test Agent");

        assertEq(registry.agentCount(), 1);

        (
            string memory name,
            address owner,
            bool active
        ) = registry.agents(1);

        assertEq(name, "Test Agent");
        assertEq(owner, address(this));
        assertTrue(active);
    }

    function testDeactivateAgent() public {
        registry.registerAgent("Test Agent");

        registry.deactivateAgent(1);

        (, , bool active) = registry.agents(1);

        assertFalse(active);
    }
}