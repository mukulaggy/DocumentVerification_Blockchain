// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartConstruction {
    struct Project {
        string name;
        address contractor;
        uint256 budget;
        uint256 deadline;
        bool completed;
    }

    address public owner;
    mapping(uint256 => Project) public projects;
    uint256 public projectCount;

    event ProjectCreated(uint256 projectId, string name, address contractor, uint256 budget, uint256 deadline);
    event ProjectCompleted(uint256 projectId, address contractor);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier onlyContractor(uint256 projectId) {
        require(msg.sender == projects[projectId].contractor, "Only assigned contractor can update status");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createProject(string memory _name, address _contractor, uint256 _budget, uint256 _deadline) public onlyOwner {
        projectCount++;
        projects[projectCount] = Project(_name, _contractor, _budget, _deadline, false);
        emit ProjectCreated(projectCount, _name, _contractor, _budget, _deadline);
    }

    function markProjectCompleted(uint256 projectId) public onlyContractor(projectId) {
        require(!projects[projectId].completed, "Project already completed");
        projects[projectId].completed = true;
        emit ProjectCompleted(projectId, msg.sender);
    }

    function getProjectDetails(uint256 projectId) public view returns (string memory, address, uint256, uint256, bool) {
        Project memory p = projects[projectId];
        return (p.name, p.contractor, p.budget, p.deadline, p.completed);
    }
}
