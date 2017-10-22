pragma solidity ^0.4.18;

contract Hackathon {
  struct category {
    string description;
    uint reward;
    uint bond;
    uint deadline;
    uint winnerID;
    string status;
    address creator;
  }

  struct submission {
    uint categoryID;
    string fileHash;
    string workReferences;
    string contributorReferences;
    address creator;
  }
  mapping(address => uint256) public Balances;
  mapping(uint => category) Categories;
  mapping(uint => submission) Submissions;
  uint numCategories;
  uint numSubmissions;

  function deposit() payable returns(bool success) {
    Balances[msg.sender] += msg.value;
    return true;
  }

  function createCategory(string description, uint reward, uint bond, uint deadline) public returns (uint categoryID){
    if (reward > Balances[msg.sender]) {
      return 0;
    }
    Balances[msg.sender] -= reward;
    categoryID = numCategories++;
    Categories[categoryID].description = description;
    Categories[categoryID].reward = reward;
    Categories[categoryID].bond = bond;
    Categories[categoryID].deadline = deadline;
    Categories[categoryID].creator = msg.sender;
  }

  function getCategory(uint categoryID) public returns (string description, uint reward, uint bond, uint deadline) {
    description = Categories[categoryID].description;
    reward = Categories[categoryID].reward;
    bond = Categories[categoryID].bond;
    deadline = Categories[categoryID].deadline;
  }

  function getSubmission(uint submissionID) public returns (uint categoryID, string fileHash) {
    categoryID = Submissions[submissionID].categoryID;
    fileHash = Submissions[submissionID].fileHash;
  }

  function getCategoryBond(uint categoryID) public returns (uint bond) {
    return Categories[categoryID].bond;
  }

  function createSubmission(uint categoryID, string fileHash) public {
    if (Balances[msg.sender] < Categories[categoryID].bond) {
      return;
    }
    if (block.timestamp > Categories[categoryID].deadline) {
      return;
    }
    Balances[msg.sender] -= Categories[categoryID].bond;
    uint submissionID = numSubmissions++;
    Submissions[submissionID].categoryID = categoryID;
    Submissions[submissionID].fileHash = fileHash;
    Submissions[submissionID].creator = msg.sender;
  }

  function closeCategory(uint categoryID, uint winnerID) public returns (string status) {
    if (block.timestamp < Categories[categoryID].deadline) {
      return;
    }
    uint reward = Categories[categoryID].reward;
    Submissions[winnerID].creator.transfer(reward);
    Categories[categoryID].winnerID = winnerID;
    Categories[categoryID].status = "finished";
    return Categories[categoryID].status;
  }

  function getCategoryCount() public returns (uint categoryCount) {
    return numCategories;
  }

  function getSubmissionCount() public returns (uint submissionCount) {
    return numSubmissions;
  }

  function getTimestamp() public returns (uint timestamp) {
    return block.timestamp;
  }
}
