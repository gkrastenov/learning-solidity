# Tokens

## Introduction
The "token": blockchain’s most powerful and most misunderstood tool.

A token is a representation of something in the blockchain. This something can be money, time, services, shares in a company, a virtual pet, anything. By representing things as tokens, we can allow smart contracts to interact with them, exchange them, create or destroy them.

## Token contract
A `token contract` is simply an Ethereum smart contract. `Sending tokens` actually means "calling a method on a smart contract that someone wrote and deployed". At the end of the day, a token contract is not much more than a mapping of addresses to balances, plus some methods to add and subtract from those balances.

It is these balances that represent the tokens themselves. Someone "has tokens" when their balance in the token contract is non-zero.

## Standards
1. `ERC20`: the most widespread token standard for fungible assets, albeit somewhat limited by its simplicity.

2. `ERC721`: the de-facto solution for non-fungible tokens, often used for collectibles and games.

3. `ERC777`: a richer standard for fungible tokens, enabling new use cases and building on past learnings. Backwards compatible with ERC20.

5. `ERC1155`: a novel standard for multi-tokens, allowing for a single contract to represent multiple fungible and non-fungible tokens, along with batched operations for increased gas efficiency.