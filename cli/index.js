fs = require("fs");
Web3 = require("web3");

contractAddress = "0x5091e86a9c46a0b29f8d41d9d3324c6b22f1fb9a";
vrAddress       = "0xee817aa03ed3917d0727e50afdd5d996aefda7b1";

console.log('get web3');
if (typeof web3 !== 'undefined') {
 web3 = new Web3(web3.currentProvider);
} else {
 // set the provider you want from web3.providers
 web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}
//console.log('web3=',web3.eth);

console.log('load file');
var source = JSON.parse(fs.readFileSync('../build/contracts/Zenko_42_Hackathon_Ballot.json', 'utf8'));
//console.log(source);

console.log('load contract');
var myContract = new web3.eth.Contract(source.abi, contractAddress);
//console.log(myContract);

//myContract.methods.get42().call().then(console.log);
//myContract.methods.registerTeam("xxx").send({from: vrAddress}).then(console.log);
myContract.methods.getTeamIdbyName("zzz").call().then(console.log);
