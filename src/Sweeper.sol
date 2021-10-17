// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import { IERC20 } from '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract Sweeper {
    function sweep(
        IERC20 _token, 
        address _to, 
        uint _value
    ) public {
        // _token.transfer(_to, _value);
    }
}
