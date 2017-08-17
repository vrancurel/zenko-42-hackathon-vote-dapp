fs = require("fs");
Web3 = require("web3");

contractAddress = "0xbf2D4d0F21456461C4441320567f0AB5D7875019";
kwameAddress = "dd788f9fea8d8c78fa28328ab926e7884bd2c6a9";

console.log('get web3');
if (typeof web3 !== 'undefined') {
 web3 = new Web3(web3.currentProvider);
} else {
 // set the provider you want from web3.providers
 web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}
//console.log('web3=',web3.eth);

console.log('load file');
var source = JSON.parse(fs.readFileSync('../build/contracts/MetaCoin.json', 'utf8'));
//console.log(source);

console.log('load contract');
var myContract = new web3.eth.Contract(source.abi, contractAddress, {from: kwameAddress});
//console.log(myContract);

myContract.methods.getBalance(kwameAddress).call().then(console.log);
