pragma solidity ^0.5.0;

/**
 * @dev libary that convert a not null string shorter than 32 bytes in bytes
*/

library StringAsKey {
    function convert(string memory key) internal pure returns (bytes32 ret) {
        require(bytes(key).length < 32 && bytes(key).length > 0, "String too long or null string");
        assembly {
            ret := mload(add(key, 32))
        }
    }
}