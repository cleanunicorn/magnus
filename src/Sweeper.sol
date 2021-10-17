// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Sweeper {
    mapping(address => bool) private owners;

    constructor() {
        owners[msg.sender] = true;
    }

    modifier onlyOwner() {
        require(owners[msg.sender], "Only owner");
        _;
    }

    function sweep(
        IERC20 _token,
        address _to,
        uint256 _value
    ) public onlyOwner {
        _token.transfer(_to, _value);
    }

    function addOwner(address _newOwner) public {
        owners[_newOwner] = true;
    }

    function isOwner(address _owner) public view returns (bool) {
        return owners[_owner];
    }

    function untested() public pure returns (bool) {
        return false;
    }
}
