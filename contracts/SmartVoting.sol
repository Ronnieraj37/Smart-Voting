//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartVoting{

    struct Candidate{
        string name;
        address canAddress;
        uint numVotes;
    }

    struct Voter{
        string name;
        bool authorised;
        bool voted;
        uint who;
    }

    address public owner ;

    string public electionName;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    uint public totalVotes; 

    function startElection(string memory _electionName) public{
        owner = msg.sender;
        electionName = _electionName;
    }

    function addCandidate(string memory _newCandidate, address _canAddress) onlyOwner public {
        candidates.push(Candidate(_newCandidate,_canAddress,0));
    }

    // function authorizeVoter(address _voterAddress) onlyOwner public {
    //     voters[_voterAddress].authorised = true;
    //     voters[_voterAddress].voted = false;
    // }

    function enrollVoter(address _voterAddress, string memory _voterName) public payable{
        require(msg.value >= 10e14,"Atleast 0.01Eth Required to become Voter!");
        voters[_voterAddress].name = _voterName;
        voters[_voterAddress].authorised = true;
        voters[_voterAddress].voted = false;
    }

    function getNumCandidates() public view returns(uint) {
        return candidates.length;
    }

    function voting(uint _index) public {
        require(voters[msg.sender].authorised == true ,"You are Not a VOTER..");
        require(voters[msg.sender].voted == false ,"You Have Already VOTED..");
        voters[msg.sender].who = _index;
        voters[msg.sender].voted = true;
        candidates[_index].numVotes++;
        totalVotes++;
    }

    function endVoting() public onlyOwner returns(string memory _winner) {
        Candidate memory winner = candidates[0];
        for(uint i=0;i<candidates.length;i++){
            if(winner.numVotes < candidates[i].numVotes){
                winner = candidates[i];
            }
        }
        (bool success,) = winner.canAddress.call{value: address(this).balance}("");
        require(success,"Failed to Declare Win..");
        return winner.name;
    }
    modifier onlyOwner{
        require(owner==msg.sender);
        _;
    }
}