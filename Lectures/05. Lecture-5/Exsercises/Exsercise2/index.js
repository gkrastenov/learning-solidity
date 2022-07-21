let Web3 = require("web3"); 

let web3 = new Web3(new Web3.providers.WebsocketProvider('http://127.0.0.1:7545'));

let abi = [
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "previousOwner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "OwnershipTransferred",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "incrementBy",
				"type": "uint256"
			}
		],
		"name": "count",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getCounter",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "transferOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]

let bytecode = '60806040526000600155600060025534801561001a57600080fd5b50336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055506105538061006a6000396000f3fe608060405234801561001057600080fd5b506004361061004c5760003560e01c80633b3546c8146100515780638ada066e146100825780638da5cb5b146100a1578063f2fde38b146100bf575b600080fd5b61006b60048036038101906100669190610351565b6100db565b6040516100799291906103b7565b60405180910390f35b61008a610176565b6040516100989291906103b7565b60405180910390f35b6100a9610187565b6040516100b6919061039c565b60405180910390f35b6100d960048036038101906100d49190610324565b6101ab565b005b60008060008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff161461013657600080fd5b826002600082825461014891906103e0565b925050819055506001600081548092919061016290610472565b919050555060015460025491509150915091565b600080600154600254915091509091565b60008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b60008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff161461020357600080fd5b600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff16141561023d57600080fd5b8073ffffffffffffffffffffffffffffffffffffffff1660008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e060405160405180910390a3806000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555050565b600081359050610309816104ef565b92915050565b60008135905061031e81610506565b92915050565b60006020828403121561033a576103396104ea565b5b6000610348848285016102fa565b91505092915050565b600060208284031215610367576103666104ea565b5b60006103758482850161030f565b91505092915050565b61038781610436565b82525050565b61039681610468565b82525050565b60006020820190506103b1600083018461037e565b92915050565b60006040820190506103cc600083018561038d565b6103d9602083018461038d565b9392505050565b60006103eb82610468565b91506103f683610468565b9250827fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0382111561042b5761042a6104bb565b5b828201905092915050565b600061044182610448565b9050919050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b6000819050919050565b600061047d82610468565b91507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8214156104b0576104af6104bb565b5b600182019050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b600080fd5b6104f881610436565b811461050357600080fd5b50565b61050f81610468565b811461051a57600080fd5b5056fea26469706673582212205562daccbdeb86e5b06e4936eb97a1173c6bce4befe1cecc7b4264cc0a12a04664736f6c63430008070033';

// create the contract instance
let myContract = new web3.eth.Contract(abi, null, {
    data: bytecode
});

let currentAccount = '0x4fB3e956afE413A81B22574760ab8d276ad7255F';
let contractInstance;

myContract.deploy().send({
    from: currentAccount,
    gasPrice: 4000000,
    gas: 1500000,
}).then((instance) => {
    console.log("Contract mined at " + instance.options.address);
    contractInstance = instance;
});

// increase the counter
contractInstance.methods.count(10).send({"from" : currentAccount}, function(error, result){
    if(!error) { 
        console.log("Increased");
    } else {
        console.log(error) // Error: VM Exception while processing transaction: revert
    }
});

// read the counter
contractInstance.methods.getCounter().call({"from" : currentAccount}, function(error, result){
    if(!error) {
        console.log("Successfully");
    }
});