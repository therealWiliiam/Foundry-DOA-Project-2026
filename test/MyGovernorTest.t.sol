// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {MyGovernor} from "../src/MyGovernor.sol";
import {Box} from "../src/Box.sol";
import {TimeLock} from "../src/TimeLock.sol";
import {GovToken} from "../src/GovToken.sol";

contract MyGovernorTest is Test {

    MyGovernor governor;
    Box box;
    TimeLock timelock;
    GovToken govToken;

    uint256 constant INITIAL_SUPPLY = 100 ether;
    uint256 constant MIN_DELAY = 3600;
    uint256 public constant VOTING_DELAY = 1;
    uint256 public constant VOTING_PERIOD = 50400;
    uint256[] values;

    address public USER = makeAddr("user");
    address[] proposers;
    address[] executors;
    address[] targets;  

    bytes[] calldatas;

    function setUp() public {
        govToken = new GovToken();
        govToken.mint(USER, INITIAL_SUPPLY);

        vm.startPrank(USER);
        govToken.delegate(USER);
        timelock = new TimeLock(MIN_DELAY, proposers, executors);
        governor = new MyGovernor(govToken, timelock);

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();
        bytes32 adminRole = timelock.DEFAULT_ADMIN_ROLE();

        timelock.grantRole(proposerRole, address(governor));
        timelock.grantRole(executorRole, address(0));
        timelock.revokeRole(adminRole, USER);
        vm.stopPrank();

        box = new Box();
        box.transferOwnership(address(timelock));  
        
    }

    function testCantUpdateBoxWithoutGovernance() public {
        vm.expectRevert();
        box.store(1);
    }

    
function testGovernanceUpdatesBox() public {
    uint256 valueToStore = 888;
    string memory description = "store 1 in Box";

    // Prepare proposal
    values.push(0);
    calldatas.push(abi.encodeWithSignature("store(uint256)", valueToStore));
    targets.push(address(box));

    uint256 proposalId = governor.propose(
        targets,
        values,
        calldatas,
        description
    );

    console.log("Block before:", block.number);
    console.log("Token clock before:", govToken.clock());
    console.log("Snapshot:", governor.proposalSnapshot(proposalId));

    vm.roll(7202);

    console.log("Block after:", block.number);
    console.log("Token clock after:", govToken.clock());
    console.log("Proposal state:", uint256(governor.state(proposalId)));

    console.log("Initial State:", uint256(governor.state(proposalId)));

    // Move past the voting delay
    vm.roll(block.number + VOTING_DELAY + 1);
    vm.warp(block.timestamp + VOTING_DELAY + 1);

    console.log("Voting State:", uint256(governor.state(proposalId)));

    // Cast vote
    string memory reason = "because i feel like having a reason";

    vm.prank(USER);
    governor.castVoteWithReason(proposalId, 1, reason);

    // Move past the voting period
    vm.roll(block.number + VOTING_PERIOD + 1);
    vm.warp(block.timestamp + VOTING_PERIOD + 1);

    console.log("Post-voting State:", uint256(governor.state(proposalId)));

    // Queue proposal
    bytes32 descriptionHash = keccak256(bytes(description));

    governor.queue(targets, values, calldatas, descriptionHash);

    console.log("Queued State:", uint256(governor.state(proposalId)));

    // Wait for timelock delay
    vm.warp(block.timestamp + MIN_DELAY + 1);

    // Execute proposal
    governor.execute(targets, values, calldatas, descriptionHash);

    assertEq(box.getNumber(), valueToStore);
    console.log("Box value:", box.getNumber());
}

}