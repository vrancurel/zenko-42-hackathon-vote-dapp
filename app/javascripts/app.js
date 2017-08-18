// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import zenko_42_hackathon_ballot_artifacts from '../../build/contracts/Zenko_42_Hackathon_Ballot.json'

// Zenko_42_Hackathon_Ballot is our usable abstraction, which we'll use through the code below.
var Zenko_42_Hackathon_Ballot = contract(zenko_42_hackathon_ballot_artifacts);

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts;
var account;

window.App = {
  start: function() {
    var self = this;

    // Bootstrap the Zenko_42_Hackathon_Ballot abstraction for Use.
    Zenko_42_Hackathon_Ballot.setProvider(web3.currentProvider);

    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length == 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
        return;
      }

      accounts = accs;
      account = accounts[0];

      self.getWinner();
    });
  },

  setStatus: function(message) {
    var status = document.getElementById("status");
    status.innerHTML = message;
  },

  getWinner: function() {
    var self = this;

    var meta;
    Zenko_42_Hackathon_Ballot.deployed().then(function(instance) {
      meta = instance;
	console.log('account ', account);
      return meta.getWinner.call();//{from: account});
    }).then(function(value) {
      console.log('value ', JSON.stringify(value));
      var winner_element = document.getElementById("winner");
      winner_element.innerHTML = value.valueOf();
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error getting winner; see log.");
    });
  },

  getTeamIdByName: function() {
    var self = this;

    var id_team_name = document.getElementById("id_team_name").value;

    var meta;
    Zenko_42_Hackathon_Ballot.deployed().then(function(instance) {
      meta = instance;
	console.log('account ', account);
      return meta.getTeamIdbyName.call(id_team_name, {from: account});
	//return meta.getWinner.call();//{from: account});
    }).then(function(value) {
      console.log('value ', JSON.stringify(value));
      var winner_element = document.getElementById("winner");
      winner_element.innerHTML = value.valueOf();
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error getting winner; see log.");
    });
  },

  registerTeam: function() {
    var self = this;

    var team_name = document.getElementById("team_name").value;

    this.setStatus("Initiating transaction... (please wait)");

    var meta;
    Zenko_42_Hackathon_Ballot.deployed().then(function(instance) {
      meta = instance;
	console.log('team_name', team_name);
      return meta.registerTeam(team_name, {from: account});
    }).then(function(value) {
      console.log('value ', JSON.stringify(value));
      self.setStatus("Transaction complete!");
      self.getWinner();
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error sending coin; see log.");
    });
  },

  registerVoter: function() {
    var self = this;

    var voter_name = document.getElementById("voter_name").value;
    var voter_address = document.getElementById("voter_address").value;

    this.setStatus("Initiating transaction... (please wait)");

    var meta;
    Zenko_42_Hackathon_Ballot.deployed().then(function(instance) {
      meta = instance;
      return meta.registerVoter(voter_name, voter_address, {from: account});
    }).then(function(value) {
      console.log('value ', JSON.stringify(value));
      self.setStatus("Transaction complete!");
      self.getWinner();
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error sending coin; see log.");
    });
  },

  voteForTeam: function() {
    var self = this;

    var votee_team_name = document.getElementById("votee_team_name").value;

    this.setStatus("Initiating transaction... (please wait)");

    var meta;
    Zenko_42_Hackathon_Ballot.deployed().then(function(instance) {
      meta = instance;
      console.log('votee_team_name', votee_team_name);
      return meta.voteForTeam(votee_team_name, {from: account});
    }).then(function(value) {
      console.log('value ', JSON.stringify(value));
      self.setStatus("Transaction complete!");
      self.getWinner();
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error sending coin; see log.");
    });
  }

};

window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 Zenko_42_Hackathon_Ballot, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.warn("No web3 detected. Falling back to http://localhost:8545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
  }

  App.start();
});
