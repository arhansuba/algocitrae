// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract Governance is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    struct Proposal {
        uint256 id;
        address proposer;
        string description;
        uint256 voteWeight;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;
    }

    EnumerableSet.AddressSet private voters;
    mapping(uint256 => Proposal) public proposals;
    mapping(address => uint256) public voteWeights;

    IERC20 public votingToken;
    uint256 public minProposalWeight;
    uint256 public minPassWeight;
    uint256 public proposalCount;

    event NewProposal(uint256 indexed proposalId, address indexed proposer, string description);
    event Vote(uint256 indexed proposalId, address indexed voter, uint256 weight, bool choice);
    event ProposalResult(uint256 indexed proposalId, bool passed);

    constructor(IERC20 _votingToken, uint256 _minProposalWeight, uint256 _minPassWeight, address _owner) Ownable(_owner) {
        votingToken = _votingToken;
        minProposalWeight = _minProposalWeight;
        minPassWeight = _minPassWeight;
    }

    function propose(string memory _description) external {
        require(voteWeights[msg.sender] >= minProposalWeight, "Insufficient vote weight");
        uint256 proposalId = proposalCount;
        proposals[proposalId] = Proposal(proposalId, msg.sender, _description, 0, 0, 0, false);
        emit NewProposal(proposalId, msg.sender, _description);
        proposalCount++;
    }

    function vote(uint256 _proposalId, bool _yes) external {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.id != 0, "Proposal does not exist");
        require(voteWeights[msg.sender] > 0, "Insufficient vote weight");
        uint256 weight = voteWeights[msg.sender];
        if (_yes) {
            proposal.yesVotes += weight;
        } else {
            proposal.noVotes += weight;
        }
        proposal.voteWeight += weight;
        emit Vote(_proposalId, msg.sender, weight, _yes);
    }

    function executeProposal(uint256 _proposalId) external onlyOwner {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.id != 0, "Proposal does not exist");
        require(!proposal.executed, "Proposal already executed");
        if (proposal.voteWeight >= minPassWeight && proposal.yesVotes > proposal.noVotes) {
            proposal.executed = true;
            // Implement your proposal execution logic here
            emit ProposalResult(_proposalId, true);
        } else {
            emit ProposalResult(_proposalId, false);
        }
    }

    function addVoter(address _voter, uint256 _weight) external onlyOwner {
        require(_weight > 0, "Weight must be greater than zero");
        voteWeights[_voter] = _weight;
        voters.add(_voter);
    }

    function removeVoter(address _voter) external onlyOwner {
        voteWeights[_voter] = 0;
        voters.remove(_voter);
    }

    function getVoters() external view onlyOwner returns (address[] memory) {
        return voters.values();
    }
}
