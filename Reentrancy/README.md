# Reentrancy

## Reentrancy Attack Scenario

1. The vulnerable smart contract has 10 eth.
2. An attacker stores 1 eth using the deposit function.
3. An attacker calls the withdraw function and points to a malicious contract as a recipient.

Now withdraw function will verify if it can be executed:
4. Does the attacker have 1 eth on their balance? Yes – because of their deposit.
5. Transfer 1 eth to a malicious contract. (Note: attacker balance has NOT been updated yet)
6. Fallback function on received eth calls withdraw function again.

## Description
The attack function calls the withdraw function in the victim’s contract. When the token is received, the fallback function calls back the withdraw function. Since the check is passed contract sends the token to the attacker, which triggers the fallback function.

## How to Protect Smart Contract Against a Reentrancy Attack?
To prevent a reentrancy attack in a Solidity smart contract, you should:

1. Ensure all state changes happen before calling external contracts, i.e., update balances or code internally before calling external code
2. Use function modifiers that prevent reentrancy