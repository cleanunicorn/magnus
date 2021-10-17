// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "ds-test/test.sol";

import { Sweeper } from "../Sweeper.sol";
import "./utils/Token.sol";

contract SweeperTest is DSTest {
    Sweeper sweeper;
    Token token;


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

        sweeper.sweep(token, address(this), 100);
        assertEq(token.balanceOf(address(sweeper)), 0);
        assertEq(token.balanceOf(address(this)), 1000);
    }
}