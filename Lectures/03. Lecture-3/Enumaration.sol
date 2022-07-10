// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

contract Enumaration {
    enum Colors { Blue, Red, Green}

    Colors choice;
    Colors constant defaultChoice = Colors.Green;

    function chooseRed() public {
        choice = Colors.Red;
    }

    function chooseColor(uint _color) public {
        choice = Colors(_color);
    }

    // Returned type will be converted to uint8
    // since enums are not part of ABI
    // if uint8 do not fill all options, uint16 wil be used and so on.
    function getChoice() public view returns(Colors) {
        return choice;
    }

    function getDefaultChoice() public pure returns(uint) {
        return uint(defaultChoice);
    }
}