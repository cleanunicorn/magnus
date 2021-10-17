// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "ds-test/test.sol";

import {Sweeper} from "../Sweeper.sol";
import {MasterSweeper} from "../MasterSweeper.sol";
import "./utils/Token.sol";
import "./utils/Caller.sol";

contract MasterSweeperTest is DSTest {
    MasterSweeper private master_sweeper;
    
    Token[] private tokens;
    Sweeper[] private sweepers;

    function setUp() public {
        // Create the Master Sweeper
        master_sweeper = new MasterSweeper();

        // Create a few generic tokens
        for (uint i = 0; i < 10; i++) {
            tokens.push(new Token("Generic Token", "$$$"));
        }

        // Create a few sweepers
        // Deploy a number of sweepers
        for (uint i = 0; i < 10; i++) {
            address sweeper = master_sweeper.deploySweeper();
            sweepers.push(Sweeper(sweeper));
        }

    }

    function testDeploySweeper() public {
        uint sweeper_count = master_sweeper.sweeperCount();

        address sweeper = master_sweeper.deploySweeper();

        address last_created_sweeper = master_sweeper.getSweeper(sweeper_count);

        assertTrue(last_created_sweeper == sweeper);
        assertTrue(sweeper != address(0), "Expecting a non null address for deployed sweeper");
    }

    function testSweepAll() public logs_gas() {
        uint sweeper_count = 10;
        uint tokens_count = 10;
        uint tokens_to_mint = 1000_000e18;       


        // Deploy a number of sweepers
        for (uint i = 0; i < sweeper_count; i++) {
            address sweeper = address(sweepers[i]);

            for (uint j = 0; j < tokens_count; j++)  {
                tokens[j].mint(address(sweeper), tokens_to_mint);
            }            
        }

        // Create a token list in memory
        address[] memory tokens_addr = new address[](tokens.length);
        for (uint i = 0; i < tokens.length; i++) {
            tokens_addr[i] = address(tokens[i]);
        }

        master_sweeper.sweepAll(tokens_addr);

        // Check that all the tokens are in the token holder
        for (uint i = 0; i < tokens_count; i++) {
            uint swept_tokens = tokens[i].balanceOf(address(this));
            assertEq(swept_tokens, tokens_to_mint * sweeper_count, "Expecting all tokens to be swept");
        }
    }

    
}

// Users
contract User1 is Caller {/* */}
