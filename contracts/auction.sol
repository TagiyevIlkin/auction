// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract Auction{
    // Declare state variables
    address payable public owner;
    // startBlock and endBlock helps us to calculate the time
    uint public startBlock;
    uint public endBlock;
    // Hash of stored files
    string public ipfsHash;

    // Dclare auction state enum and var
    enum State{ Started, Running, Ended, Cancelled}
    State public auctionState;

    uint public highestBindingBid;
    // Highest bidder address
    address payable public  highestBidder;
    // Declare mapping to holds addresses and bids
    mapping(address=>uint)  public bids;
    
    uint bidIncrement;

    constructor(){
        // Convert the address to payable and assign it to owner
        owner=payable(msg.sender);
        // Set the action state to Running
        auctionState=State.Running;
        // Initialize the startBlock to current block
        startBlock=block.number;
        // Initialize the startBlock to startBlock + a week in seconds(about 40320)
        endBlock=startBlock+40320;

        ipfsHash="";
        bidIncrement=100;
    }

}