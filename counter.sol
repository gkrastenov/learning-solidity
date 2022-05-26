// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Counter{
    int count;
    address lastModifiedAddress;

    function incrementCountWith(int _number) external {
        count += _number;
        lastModifiedAddress = msg.sender;
    }

    function decrementCountWith(int _number) external {
        count -= _number;
        lastModifiedAddress = msg.sender;
    }

    function getCount() public view returns (int){
        return count;
    }

    function getlastModifiedAddress() public view returns (address) {
        return lastModifiedAddress;
    }

    function incrementCountWithTimestamp() external view returns (int) {
        return count + int(block.timestamp);
    }
}