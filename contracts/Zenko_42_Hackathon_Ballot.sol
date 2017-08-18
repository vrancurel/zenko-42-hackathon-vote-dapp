pragma solidity ^0.4.15;

contract Zenko_42_Hackathon_Ballot {
    
    uint8 constant VOTES_PER_VOTER = 3;
    bool ballotClosed;
    
    struct Team {
        uint id;
        int votes;
        address addr;
        bool exists;
    }
    
    struct Voter {
        uint8 weight;
        uint8 votesLeft;
        string name;
    }
    
    address chairperson;
    mapping(string => Team) teams;
    string[] teamNames;
    mapping(address => Voter) voters;
    
    // Constructor, the caller becomes chairperson of this ballot
    function Zenko_42_Hackathon_Ballot() {
        chairperson = msg.sender;
        ballotClosed = false;
        // the chair person is also a super voter
        voters[chairperson].weight = 1;
        voters[chairperson].name = "chair";
        voters[chairperson].votesLeft = VOTES_PER_VOTER * 2;
    }
    
    /// May only be called by $(chairperson).
    function registerVoter(string name, address voter) returns (string) {
        if (msg.sender != chairperson || voters[voter].weight > 0) return "Who in the blue hell are you?";
        voters[voter].weight = 1;
        voters[voter].name = name;
        voters[voter].votesLeft = VOTES_PER_VOTER;
        
        return "We have a new voter!";
    }
    
     /// May only be called by $(chairperson). a super voter has twice the amount of votes
    function registerSuperVoter(string name, address voter) returns (string) {
        if (msg.sender != chairperson || voters[voter].weight > 0) return "Who in the blue hell are you?";
        voters[voter].weight = 1;
        voters[voter].name = name;
        voters[voter].votesLeft = VOTES_PER_VOTER*2;
        
        return "We have a new super voter!";
    }
    
    /// May only be called by $(chairperson).
    function registerTeam(string teamName) returns (string) {
        if (msg.sender != chairperson) return "Know Your Role And Shut Your Mouth";
        
        Team storage t = teams[teamName];
        if (t.exists == true) // Test that the team exists
            return "Team already exists...";
        
        t.id = teamNames.length;
        t.votes = 0;
        t.exists = true;
        
        teamNames.push(teamName);
        
        return "Keep it coming";
    }
    
    function voteForTeam(string teamName) returns (string) {
        if (ballotClosed) return "Ballot closed";
        
        
        Voter storage voter = voters[msg.sender];
        if (voter.votesLeft <= 0) return "No votes left, Know Your Role And Shut Your Mouth"; // Can't vote more than your alloted votes
        Team storage t = teams[teamName];
        if (t.exists == false) // Test that the team exists
            return "Unkwown team, Know Your Role And Shut Your Mouth";

        voter.votesLeft -= 1;
        t.votes += voter.weight;
        
        return "This is The Most Electrifying Ballot In Education today";
    }
    
    function getTeamNamebyId(uint id) constant returns(string) {
        return teamNames[id];
    }
    
    function getTeamIdbyName(string name) constant returns(int) {
        bytes32 hash = sha3(name);
        for (uint p = 0; p < teamNames.length; p++) {
            if (hash == sha3(teamNames[p])) {
                return int(p);
            }
        }
        
        return -1;
    }
    
    function getTeamVotes(string teamName) constant returns(int) {
        if (msg.sender != chairperson) return -1;
        return teams[teamName].votes;
    }
    
    function getWinnerID() constant private returns (uint) {
        uint winnerID = 0;
        int winnerScore = -1;
        
        for (uint p = 0; p < teamNames.length; p++) {
            Team memory t = teams[teamNames[p]];
            if (t.votes > winnerScore) {
             winnerID = t.id;
             winnerScore = t.votes;
           }
        }
        
        return winnerID;
    }
    
    function getSecondID() constant private returns (uint) {
        uint winnerID = getWinnerID();
        uint secondID = 0;
        int secondScore = -1;
        
        for (uint p = 0; p < teamNames.length; p++) {
            if (p == winnerID)
                continue;
            
            Team memory t = teams[teamNames[p]];
            if (t.votes > secondScore) {
             secondID = t.id;
             secondScore = t.votes;
           }
        }
        
        return secondID;
    }
    
    function getThirdID() constant private returns (uint) {
        uint winnerID = getWinnerID();
        uint secondID = getSecondID();
        uint thirdID = 0;
        int thirdScore = -1;
        
        for (uint p = 0; p < teamNames.length; p++) {
            if (p == winnerID || p == secondID)
                continue;
            
            Team memory t = teams[teamNames[p]];
            if (t.votes > thirdScore) {
             thirdID = t.id;
             thirdScore = t.votes;
           }
        }
        
        return thirdID;
    }
    
    function getVotesLeft() constant returns (uint) {
        Voter storage voter = voters[msg.sender];
        return voter.votesLeft;
    }
    
    function getWinner() constant returns (string) {
        if (!ballotClosed && msg.sender != chairperson) return "You can't see that yet";
        return teamNames[getWinnerID()];
    }
    
    function getSecond() constant returns (string) {
        if (!ballotClosed && msg.sender != chairperson) return "You can't see that yet";
        return teamNames[getSecondID()];
    }
    
    function getThird() constant returns (string) {
        if (!ballotClosed && msg.sender != chairperson) return "You can't see that yet";
        return teamNames[getThirdID()];
    }
    
    function closeBalllot() {
       if (msg.sender != chairperson) return;
       ballotClosed = true;
    }
    
    function reopenBalllot() {
       if (msg.sender != chairperson) return;
       ballotClosed = false;
    }
    
    function kill() { 
        if (msg.sender != chairperson) return;
        suicide(chairperson);       // kills this contract and sends remaining funds back to creator
    }
    
}
