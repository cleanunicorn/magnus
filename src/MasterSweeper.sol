// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import {Sweeper} from "./Sweeper.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MasterSweeper {
    Sweeper[] internal sweepers;

    function deploySweeper() external returns (address) {
        Sweeper new_sweeper =  new Sweeper();
        sweepers.push(new_sweeper);

        return address(new_sweeper);
    }

    function sweeperCount() external view returns (uint) {
        return sweepers.length;
    }

    function getSweeper(uint index) external view returns (address) {
        return address(sweepers[index]);
    }

    function sweepAll(address[] calldata tokens) external {
        uint sweeper_count = sweepers.length;

        for (uint i = 0; i < sweeper_count; i++) {
            Sweeper sweeper = sweepers[i];

            sweeper.sweepAll(
                tokens,
                msg.sender
            );
        }
    }
}