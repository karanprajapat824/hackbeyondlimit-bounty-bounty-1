// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {

    // Candidate structure
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    // Mapping to store candidates
    mapping(uint => Candidate) public candidates;
    
    // Mapping to keep track of whether an address has voted or not
    mapping(address => bool) public voters;

    uint public candidatesCount;
    uint public totalVotes;

    // Events to log actions on the blockchain
    event Voted(address indexed voter, uint candidateId);
    event CandidateAdded(uint candidateId, string name);

    // Constructor to initialize contract with candidate names
    constructor(string[] memory candidateNames) {
        candidatesCount = 0;
        totalVotes = 0;
        
        // Add candidates to the system
        for (uint i = 0; i < candidateNames.length; i++) {
            addCandidate(candidateNames[i]);
        }
    }

    // Function to add a candidate to the voting list
    function addCandidate(string memory _name) private {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        emit CandidateAdded(candidatesCount, _name);
    }

    // Function to vote for a candidate
    function vote(uint _candidateId) external {
        // Check if the address has already voted
        require(!voters[msg.sender], "You have already voted.");
        
        // Ensure that the candidate ID is valid
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID.");

        // Register the vote
        candidates[_candidateId].voteCount++;
        voters[msg.sender] = true;
        totalVotes++;

        emit Voted(msg.sender, _candidateId);
    }

    // Function to get the total number of votes for a candidate
    function getVoteCount(uint _candidateId) external view returns (uint) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID.");
        return candidates[_candidateId].voteCount;
    }

    // Function to get the details of a candidate
    function getCandidate(uint _candidateId) external view returns (string memory name, uint voteCount) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID.");
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.name, candidate.voteCount);
    }

    // Function to get the total number of votes cast
    function getTotalVotes() external view returns (uint) {
        return totalVotes;
    }
}
