pragma solidity ^0.4.15;

contract Zenko_42_Hackathon_Ballot {
    
    uint8 constant VOTES_PER_VOTER = 3;
    
    struct Team {
        string name;
        uint votes;
        address addr;
    }
    
    struct Voter {
        uint8 weight;
        uint8 votesLeft;
        string name;
    }
    
    
    address chairperson;
    mapping(string => Team) teams;
    mapping(address => Voter) voters;
    string firstTeam;
    uint firstTeamVotes = 0;
    string secondTeam;
    uint secondTeamVotes = 0;
    string thirdTeam;
    uint thirdTeamVotes = 0;
    
    // Constructor, the caller becomes chairperson of this ballot
    function Zenko_42_Hackathon_Ballot() {
        chairperson = msg.sender;
        // the chair person is also a voter
        voters[chairperson].weight = 1;
        voters[chairperson].name = "chair";
        voters[chairperson].votesLeft = VOTES_PER_VOTER;
    }
    
    /// May only be called by $(chairperson).
    function registerVoter(string name, address voter) returns (string _reply) {
        _reply = "Who in the blue hell are you?";
        if (msg.sender != chairperson || voters[voter].weight > 0) return;
        voters[voter].weight = 1;
        voters[voter].name = name;
        voters[voter].votesLeft = VOTES_PER_VOTER;
        
        
        _reply = "We have a new voter!";
    }
    
     /// May only be called by $(chairperson). a super voter has twice the amount of votes
    function registerSuperVoter(string name, address voter) returns (string _reply) {
        _reply = "Who in the blue hell are you?";
        if (msg.sender != chairperson || voters[voter].weight > 0) return;
        voters[voter].weight = 1;
        voters[voter].name = name;
        voters[voter].votesLeft = VOTES_PER_VOTER*2;
        
        _reply = "We have a new super voter!";
    }
    
    /// May only be called by $(chairperson).
    function registerTeam(string n, address a) {
        if (msg.sender != chairperson) return;
        
        Team storage t = teams[n];
        t.name = n;
        t.votes = 0;
        t.addr = a;
    }
    
    function voteForTeam(string teamName) returns (string _msg) {
        _msg = "Know Your Role And Shut Your Mouth";
        
        Voter storage voter = voters[msg.sender];
        if (voter.votesLeft <= 0) return; // Can't vote more than your alloted votes
        Team storage t = teams[teamName];
        if (t.addr == 0) // Test that the team exists
            return;
        
        _msg = "This is The Most Electrifying Ballot In Education today";
        
        voter.votesLeft -= 1;
        t.votes += voter.weight;
        
        if (t.votes > firstTeamVotes) {
            // We have a new winner! // cascade down
            thirdTeam = secondTeam;
            thirdTeamVotes = secondTeamVotes;
            secondTeam = firstTeam;
            secondTeamVotes = firstTeamVotes;
            firstTeam = t.name;
            firstTeamVotes = t.votes;
        } else if (t.votes > secondTeamVotes) {
            // We have a new winner! // cascade down
            thirdTeam = secondTeam;
            thirdTeamVotes = secondTeamVotes;
            secondTeam = t.name;
            secondTeamVotes = t.votes;
        }
         else if (t.votes > thirdTeamVotes) {
            // We have a new winner! // cascade down
            thirdTeam = t.name;
            thirdTeamVotes = t.votes;
        } 
    }
    
    function getWinner() returns (string _winner){
        _winner = firstTeam;
    }
    
    function getSecond() returns (string _winner){
        _winner = secondTeam;
    }
    
    function getThird() returns (string _winner){
        _winner = thirdTeam;
    }
    
    /* Utility functions */
    function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
        for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }

    function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
        return strConcat(_a, _b, _c, _d, "");
    }

    function strConcat(string _a, string _b, string _c) internal returns (string) {
        return strConcat(_a, _b, _c, "", "");
    }

    function strConcat(string _a, string _b) internal returns (string) {
        return strConcat(_a, _b, "", "", "");
    }
    
}
