// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Test.sol";

error Unauthorized();

contract OwnerUpOnly {
    address public immutable owner;
    uint256 public count;

    constructor() {
        owner = msg.sender;
    }

    function increment() external {
        if (msg.sender != owner) {
            revert Unauthorized();
        }
        count++;
    }
}

contract OwnerUpOnlyTest is Test {
    OwnerUpOnly upOnlyContract;

    function setUp() public {
        upOnlyContract = new OwnerUpOnly();
    }

    function test_IncrementAsOwner() public {
        assertEq(upOnlyContract.count(), 0);
        upOnlyContract.increment();
        assertEq(upOnlyContract.count(), 1);
    }

    function test_IncrementAsOwnerWillFail_CallerIsNotOWner_ItReverts() public {
        vm.expectRevert(Unauthorized.selector);
        vm.prank(address(0));   // changes address for the next call
        upOnlyContract.increment();
        upOnlyContract.increment();
        upOnlyContract.increment();
    }
}