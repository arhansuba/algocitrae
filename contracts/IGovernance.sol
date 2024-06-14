// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGovernance {
    
    event ProposalCreated(uint256 indexed proposalId, address indexed proposer);
    event VoteCast(address indexed voter, uint256 indexed proposalId, bool support);
    event ProposalExecuted(uint256 indexed proposalId);
    event ProposalCancelled(uint256 indexed proposalId);

    struct Proposal {
        uint256 id;
        address proposer;
        uint256 startTime;
        uint256 endTime;
        uint256 forVotes;
        uint256 againstVotes;
        bool executed;
        bool cancelled;
    }

    function submitProposal(uint256 startTime, uint256 endTime) external returns (uint256);

    function vote(uint256 proposalId, bool support) external;

    function executeProposal(uint256 proposalId) external;

    function cancelProposal(uint256 proposalId) external;

    function getProposalById(uint256 proposalId) external view returns (Proposal memory);

    function getProposalState(uint256 proposalId) external view returns (bool executed, bool cancelled);
    
    function getProposalVotes(uint256 proposalId) external view returns (uint256 forVotes, uint256 againstVotes);
    
}
