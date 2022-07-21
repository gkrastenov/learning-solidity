// If you are using node.js, you need to load the Web3 library
let Web3 = require("web3"); 

// Create a web3 instance - once that is connected to a local node
let web3 = new Web3(new Web3.providers.WebsocketProvider('http://127.0.0.1:7545'));

// Getting the web3 version
web3.version 

let accountsArray;

web3.eth.getAccounts(function(error, result) {
    if(!error) {
        accountsArray = result;
    }
});

let currentAccount = accountsArray[0]; // get the first account
let otherAccount = accountsArray[1];

const txProperties =  {
    "from": currentAccount, 
    "to": otherAccount, 
    "value":2*1e18
};

web3.eth.sendTransaction(txProperties);

// get block 1 
web3.eth.getBlock(1, function(error, result) { // using callback function
    if(!error) {
        // type of res is Bignumber. We can convert to string via .valueOf()
        console.log("Block properties: ", result);
    } else {
        // error handling
    }
});

web3.eth.getTransaction('0xc292e67610c9e4f111a9aa0eb65f9dfa8d2df094922be01dd061273d743bdc93', function(error, result) {
    if(!error) {
        console.log("Transaction: ", result);
    }
});

let abi = [
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "from",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "to",
				"type": "address"
			}
		],
		"name": "TransferOwnership",
		"type": "event"
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
		"inputs": [],
		"name": "testCalculator",
		"outputs": [],
		"stateMutability": "view",
		"type": "function"
	}
]

let bytecode = '608060405234801561001057600080fd5b50336000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055506104d5806100606000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c806363aedf9f1461003b5780638da5cb5b14610045575b600080fd5b610043610063565b005b61004d6101d4565b60405161005a91906102a6565b60405180910390f35b60008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16146100bb57600080fd5b6101086002600360008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166101f89092919063ffffffff16565b60051461011857610117610412565b5b6101656014600360008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166102259092919063ffffffff16565b60111461017557610174610412565b5b6101c26005600360008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1661024d9092919063ffffffff16565b600f146101d2576101d1610412565b5b565b60008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b600080828461020791906102c1565b90508381101561021a57610219610412565b5b809150509392505050565b60008282111561023857610237610412565b5b818361024491906103a2565b90509392505050565b6000808314156102605760009050610290565b6000828461026e9190610348565b905082848261027d9190610317565b1461028b5761028a610412565b5b809150505b9392505050565b6102a0816103d6565b82525050565b60006020820190506102bb6000830184610297565b92915050565b60006102cc82610408565b91506102d783610408565b9250827fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0382111561030c5761030b610441565b5b828201905092915050565b600061032282610408565b915061032d83610408565b92508261033d5761033c610470565b5b828204905092915050565b600061035382610408565b915061035e83610408565b9250817fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff048311821515161561039757610396610441565b5b828202905092915050565b60006103ad82610408565b91506103b883610408565b9250828210156103cb576103ca610441565b5b828203905092915050565b60006103e1826103e8565b9050919050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b6000819050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052600160045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601260045260246000fdfea264697066735822122079ba4b1c752c125d1f8ddfda1baf1ac23ed8bace33f279ae9651f7aa346f4ab564736f6c63430008070033';

// create the contract instance. We can use this instance to publish or connect to a published
let myContract = new web3.eth.Contract(abi, null, {
    data: bytecode
});

let contractInstance;

myContract.deploy().send({
    from: currentAccount,
    gasPrice: 4000000,
    gas: 1500000,
}).then((instance) => {
    console.log("Contract mined at " + instance.options.address);
    contractInstance = instance;
});

// Lets call testCalculator function of the contract. If we change state of the blockchain use . send
// becaouse we need to send transaction
contractInstance.methods.testCalculator().call({"from" : currentAccount}, function(error, result){
    if(!error) {
        console.log("Successfully");
    }
});

contractInstance.methods.testCalculator().call({"from" : otherAccount}, function(error, result){
    if(!error) { // will try to catch onlyOwner modifier
        console.log("How is this possible?");
    } else {
        console.log(error) // Error: VM Exception while processing transaction: revert
    }
});


/*
// lets call a payable contract method
// notice how we convert ethers to wei
contractInstance.methods.add(5).send({"from" : currentAccount, "value": 2*1e18}, function(error, result) {
    if(!error) {
        console.log(result.valueOf()) // this will be the TX hash.
        // Web3 can not accces return values from transaction calls!
    } else {
        console.log("Not enough Ethers!");
    }
})
*/

// lets filter the blockchain for contract events.
// the callbacj will be called one event at a time
// It will scan the whole blockchain for historical events and also watch for new upcoming events
let filterObject = contractInstance.events.allEvents({fromBlock: 0, toBlock: 'latest'}, function(error, result){
    if(!error) {
        console.log("Got log: ", result);
        // result.event -> the name of the event
        // result.args -> parameters of the event
    }
})