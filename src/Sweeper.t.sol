// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "ds-test/test.sol";

import {Sweeper} from "./Sweeper.sol";
import "./test/utils/Token.sol";
import "./test/utils/Caller.sol";

contract SweeperTest is DSTest {
    Sweeper private sweeper;
    Token private token;

    function setUp() public {
        // Create the sweeper
        sweeper = new Sweeper();

        // Create a generic token
        token = new Token("Generic Token", "$$$");
    }

    function testSweep() public {
        token.mint(address(this), 1000);

        token.transfer(address(sweeper), 100);
        assertEq(token.balanceOf(address(sweeper)), 100);

        sweeper.sweep(address(token), address(this), 100);
        assertEq(token.balanceOf(address(sweeper)), 0);
        assertEq(token.balanceOf(address(this)), 1000);
    }

    function testOnlyAdminCanSweep() public {
        // Create a user without permission to sweep
        User user = new User();

        // Create tokens and add them to the sweeper
        token.mint(address(this), 1000);
        token.transfer(address(sweeper), 100);

        // Try to withdraw tokens as a different user
        (
            bool ok, /* bytes memory data */

        ) = user.externalCall(
                address(sweeper),
                abi.encodeWithSelector(
                    sweeper.sweep.selector,
                    token,
                    address(user),
                    100
                )
            );

        assertTrue(
            !ok,
            "Should not be able to sweep tokens without permission"
        );
    }

    function testShouldBeAbleToAddOwnersList() public {
        // Create a user
        User user = new User();

        assertTrue(!sweeper.isOwner(address(user)), "Should not be owner");
        sweeper.addOwner(address(user));
        assertTrue(sweeper.isOwner(address(user)), "Should be owner");
    }

    function testShouldSweepAllTokens() public {
        token.mint(address(sweeper), 1000);

        address[] memory tokens = new address[](1);
        tokens[0] = address(token);

        sweeper.sweepAll(tokens, address(this));
        assertEq(token.balanceOf(address(sweeper)), 0);
        assertEq(token.balanceOf(address(this)), 1000);
    }

    function testFuzzSweepAmount(uint256 amountToSweep, uint256 amountToMint)
        public
    {
        if (amountToSweep > amountToMint) {
            return;
        }

        token.mint(address(this), amountToMint);

        token.transfer(address(sweeper), amountToSweep);
        assertEq(token.balanceOf(address(sweeper)), amountToSweep);

        sweeper.sweep(address(token), address(this), amountToSweep);
        assertEq(token.balanceOf(address(sweeper)), 0);
        assertEq(token.balanceOf(address(this)), amountToMint);
    }

    function invariant_onlySetOwnerCanSweep() public {
        token.mint(address(sweeper), 1000);

        // sweeper.sweep(address(token), address(this), 1);

        assertEq(token.balanceOf(address(this)), 0);
    }
}

// User
contract User is Caller {
    //
}
