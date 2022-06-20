// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract MathLibrary {

    function add(int32 x, int32 y) public returns (int32){
        return x + y;
    }

    function subtract(int32 x, int32 y) public returns (int32){
        return x - y;
    }

    function multiply(int32 x, int32 y) public returns (int32){
        return x * y;
    }

    function divide(int32 x, int32 y) public returns (int32){
        require(y != 0, "Divide by zero")
        return x / y;
    }

    function raise(uint256 x, uint256 y) public returns (uint256){ 
        return x**y;
     }
}