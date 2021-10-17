// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract Caller {

    // /*
    //     Calls the address and reverts if the call succeeded.
    // */
    // function tryCall(address _addr, bytes calldata _data) external returns (bool) {
    //     bytes memory memory_data = _data;
    //     assembly {
    //         let ok := call(gas(), _addr, 0, add(memory_data, 0x20), mload(memory_data), 0, 0)
    //         let free := mload(0x40)
    //         mstore(free, ok)
    //         mstore(0x40, add(free, 32))
    //         revert(free, 32)
    //     }
    // }    

    function call(address _addr, bytes calldata _data) external returns (bool, bytes memory) {
        (bool ok, bytes memory data) = _addr.call(_data);
        return (ok, data);
    }

}
