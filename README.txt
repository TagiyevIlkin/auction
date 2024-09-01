This Solidity contract defines two smart contracts: AuctionCreator and Auction. These contracts enable the creation and management of decentralized auctions on the Ethereum blockchain.

AuctionCreator Contract
The AuctionCreator contract is responsible for creating new instances of the Auction contract. It maintains a dynamic array to store the addresses of all created auctions. The key functionality includes:

  createAuction(): Deploys a new Auction contract and stores its address.

Auction Contract
The Auction contract implements the core functionality of a decentralized auction. Key features of this contract include:

  Auction Lifecycle Management: Handles different auction states (Started, Running, Ended, Cancelled) and provides functions to start, 
  manage, and end auctions.
  Bid Management: Allows users to place bids, with the highest bid being tracked and managed automatically.
  Finalization and Cancellation: Provides functions to cancel the auction or finalize it after completion, transferring funds 
  appropriately to the highest bidder or refunding participants if the auction is cancelled.

Key Functions
  placeBid(): Allows participants to place bids during the auction period.
  cancelAuction(): Allows the auction owner to cancel the auction.
  finalizeAuction(): Finalizes the auction, distributing the funds to the auction owner and refunding any excess bids to participants.

Modifiers
  onlyOwner: Ensures that only the auction owner can perform certain actions.
  notOwner: Ensures that the auction owner cannot bid in their own auction.
  afterStart/beforeEnd: Ensures that bidding is allowed only during the auction period.
Usage
  This smart contract provides a decentralized platform for managing auctions, where users can securely place bids, and the auction owner 
  can manage the auction lifecycle. It promotes transparency, fairness, and trust by using Ethereum's immutable ledger to handle all 
  transactions and auction data.
