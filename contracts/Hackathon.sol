pragma solidity ^0.4.4;

contract Hackathon {
  struct auction {
    uint deadline;
    uint highestBid;
    address highestBidder;
    uint bidHash;
    address recipient;
  }
}