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

    function sweepAll(address[] calldata _tokens, address _to)
        public
        onlyOwner
    {
        for (uint256 i = 0; i < _tokens.length; i++) {
            IERC20 token = IERC20(_tokens[i]);
            uint256 balance = token.balanceOf(address(this));
            token.transfer(_to, balance);
        }
    }

    function addOwner(address _newOwner) public {
        owners[_newOwner] = true;
    }

    function isOwner(address _owner) public view returns (bool) {
        return owners[_owner];
    }
}
