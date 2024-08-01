// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// AuctionCreator contract creates a new instance of Auction contract
contract AuctionCreator{
    // Declare an dynamic array to store address of created Auction contract
    Auction[] public createdAuctions;

    // createAuction creates a new instance of Auction contract
    function createAuction() public  {
      // Create a new instance of Auction 
      Auction newAuction=new Auction(msg.sender);
      // Add auction instance to array
      createdAuctions.push(newAuction);
    }
}

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

    constructor(address eoa){
        // Convert the eoa(externally owned account) to payable and assign it to owner
        owner=payable(eoa);
        // Set the action state to Running
        auctionState=State.Running;
        // Initialize the startBlock to current block
        startBlock=block.number;
        // Initialize the startBlock to startBlock + a week in seconds(about 40320)
        endBlock=startBlock+40320;

        ipfsHash="";
        bidIncrement=100;
    }

    modifier notOwner(){
        require(msg.sender!=owner,"Owner is not allowed");
        _;
    }

    modifier onlyOwner(){
        require(msg.sender==owner,"Only owner is allowed");
        _;
    }

    // Auction should start after startBlock 
    modifier afterStart(){
        require(block.number>=startBlock);
        _;
    }
    // Auction should end before endBlock 
    modifier beforeEnd(){
        require(block.number<=endBlock);
        _;
    }

    // min returns the minimum value of given values
    function min(uint a,uint b)pure  internal returns(uint){
        if (a<=b){
            return a;
        }else {
            return b;
        }
        
    }

    // placeBid allows the users to bid
    function placeBid() notOwner afterStart beforeEnd public payable {
     // Check the auctionState
        require(auctionState==State.Running,"Aucting is not running");
        // Check the value
        require(msg.value>=100,"Minimum bidding value is 1000 wei");
       // Get the current bid
        uint currentBid=bids[msg.sender]+ msg.value;
        // Check if the  currentBid is greater than highestBindingBid
        require(currentBid>highestBindingBid);
        // Add the bid to mapping
        bids[msg.sender]=currentBid;

       // Check if the currentBid is less or equal to highestBid
       // If so change the highestBindingBid and keep the highestBidder same
       // If not change the highestBindingBid as well as highestBidder
       if(currentBid<=bids[highestBidder]){
        highestBindingBid=min(currentBid+bidIncrement,bids[highestBidder]);
       }else {
        highestBindingBid=min(currentBid,bids[highestBidder]+bidIncrement);
        highestBidder=payable(msg.sender);
       }
    }

    // cancelAuction sets the auctionState to the Cancelled state
    function cancelAuction()public onlyOwner{
        auctionState=State.Cancelled;
    }

    function finalizeAuction()public  {
        // Require conditions to finalize the auction
        require(auctionState==State.Cancelled || block.number>endBlock ,"Auction cannot be finalized");
        require(msg.sender==owner || bids[msg.sender]>0,"Either owner or bidder is allowed");
        // Declare local variable for recipient and the value that recipient will get
        address payable recipient;
        uint value;

        // 2 possible case
        // 1. case: Auction is cancelled
        if (auctionState==State.Cancelled){
           recipient=payable(msg.sender);
           value=bids[msg.sender];
        }else {  // 2. case: Auction ended
            // if Auction is finalized by owner, the owner will receive higest binding bid
            if (msg.sender==owner){
            recipient=owner;
            value=highestBindingBid;
            }else { // Otherwise bidder request  its funds
                // 2 cases here:
                // 1. case: Requested bidder is highestBidder
                if (msg.sender==highestBidder){
                    recipient=highestBidder;
                    value=bids[highestBidder]-highestBindingBid;
                }else { // 2. case: Requested bidder is neither owner nor highestBidder
                recipient=payable(msg.sender);
                value=bids[msg.sender];
                }
            }

        }

        // Reset the receipen bids to 0
        bids[recipient]=0;
        // Send the value to recipient
        recipient.transfer(value);
    }

}