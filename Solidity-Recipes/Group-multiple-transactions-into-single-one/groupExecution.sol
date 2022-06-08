pragma solidity ^0.6.0;

contract Utils {
    function groupExecution(uint argA, uint argB) external {
        ContactA(address(0)).executeA(argA);
        ContactB(address(0)).executeB(argB);
    }
}

contract ContactA {
    function executeA(uint argA) external{
        // do something
    }
}
contract ContactB {
    function executeB(uint argB) external{
        // do something
    }
}