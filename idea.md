// Auction structure
structure Auction{
    address Hoster;
    integer initialBidAmt;
    boolean isActive;
    // identifier for NFT
    integer/address AssetNFT;
    address winner;
    boolean buyerConfirm;
    boolean hosterConfirm;
}

// structure of user participation in auction
structure userBuy{
    integer auctionID;
    integer bidAmt;
}
// map of user to user participation in auction
unordered_map(address user , userBuy ) userBid;

// boolean map of whether hoster has paid auction fees
unordered_map(address user , bool) feesPaidToHostAuction
// boolean map of whether user has paid participation fees
unordered_map(address user , bool) feesPaidToBuyInAuction

const HOSTFESS = // WRITE SOME FEES
const BUYFEES = // WRITE SOME FEES

// mapping of a hoster to indexes of all his held auctions
unordered_map(address hoster , integer auctionsIndex[]) auctionsHeld;

// array of all auctions held
Auction[] auctions;


function makeAssetNFT(string tokenURI) public returns (integer){
   // WRITE : FUNCTION TO MAKE A NFT OF GIVEN TOKEN URI
}


function getAllAuctions(){
    return auctions;
}

// Function for hoster to start a new auction
function HostAuction(integer initialBidAmt, address AssetNFT){
    // check if hosting fees paid
    return_if_false(feesPaidToHostAuction[function_caller]);
    new auction
    Auction newAuction = Auction({
        Hoster: function_caller,
        initialBidAmt,
        isActive: true,
        AssetNFT: AssetNFT
    });
    integer auctionId = auctions.length;
    auctions.push(newAuction);
    auctionsHeld[function_caller].push(auctionId);
}

// host can end auction when he sees suitable
function endAuction(integer auctionId) {
    return_if_false(auctions[auctionId].isActive);
    return_if_false(function_caller == auctions[auctionId].Hoster);
    auctions[auctionId].isActive = false;
}


function getBalanceOfUser(address user){
    return user.balance;
}

// auction participation fees payment
function payFeesToBuy(){
    // check if user paid to participate in auction
    return_if_false(!feesPaidToBuyInAuction[function_caller]);
    feesPaidToBuyInAuction[function_caller] = true;
    // WRITE : FUNCTION TO PAY FEES 
}

// Hosting fees payment
function payFeesToHost(){
    return_if_false(!feesPaidToHostAuction[function_caller]);
    feesPaidToHostAuction[function_caller] = true;
    // WRITE : FUNCTION TO PAY FEES 
}

// 1st confirm by hoster
function confirm1ByHoster(address buyer, integer auctionId){
    return_if_false(function_caller == auctions[auctionId].Hoster);
    return_if_false(auctions[auctionId].isActive == false);
    auctions[auctionId].winner = buyer;
}

// 1st confirm by buyer
function confirm1ByBuyer(integer auctionId,integer bidAmt){
    return_if_false(auctions[auctionId].isActive == false);
    return_if_false(msg.value==bidAmt);
    userBid[user]= userBuy({
        auctionId: auctionId,
        bidAmt: bidAmt,
    })
    // WRITE : MAKE SURE MONEY TRANSFERS TO CONTRACT
}
 
function confirm2ByHoster(integer auctionId){
    return_if_false(auctions.winner!=address(0));
    auctions[auctionId].hosterConfirm = true;
    if(auctions[auctionId].buyerConfirm == true){
        transactAuction(auctionId);
    }
    if(actions[auctionId].hosterConfirm == true){
        transactAuction(auctionId);
    }
}

function confirm2ByBuyer(integer auctionId){
    return_if_false(userBid[user].auctionId==auctionId);
    auctions[auctionId].buyerConfirm = true;
    if(auctions[auctionId].hosterConfirm == true){
        transactAuction(auctionId);
    }
    if(actions[auctionId].buyerConfirm == true){
        transactAuction(auctionId);
    }
}

// execute the exchanges of the transaction
function transactAuction(integer auctionId){
    return_if_false(auctions[auctionId].hosterConfirm == true);
    return_if_false(auctions[auctionId].buyerConfirm == true);
    auctions[auctionId].buyerConfirm=false;
    auctions[auctionId].hosterConfirm=false;
    // WRITE : TRANSFER MONEY TO HOSTER
    // WRITE : TRANSFER NFT TO BUYER
    
}






PAGES

---Login ---
Will be actually done by internet identity (ICP) but for now, just a click to login simple button

---Register email---
user enters email
code sent to email
user enters correct code then email + user identity(ICP) registered in database

---Home---
If user not registered, redirect to register email page else proceed

List of auctions : data taken from getAuctionsData() function ( to be made that contains both web3 and database fetching) ( Click on any single one opens its auction page)
Create auction
Pay participation fees button

---Pay participation fees---
Pay fees to participate in auction : check feesPaidToBuyInAuction for given user, if true fees is paid user can proceed, else pay fees

---create auction---
Pay Fees to host auctionn : check feesPaidToHostAuction for given user, if true fees is paid user can proceed, else pay fees

Creating an auction takes : an image of ownership document, which is to be converted into an nft (using makeNFT function) which will later be transferred. If NFT created, initialBidAmt, address of NFT just created. (This much data is enough to create an auction on web3 part)

For database part : a title, and a description also
In database : mapping of NFT address to title and descp

---Auction---
Details of auctions (passed data as prop of this specific auction)

current biddings ( fetched here only from database of this specific auction)

If participation fees paid, user can proceed to bid
User enters amount, amount checked with current balance of user from web3, if enough, bid is placed, else error
bid here is only placed in database ( mapping of bids to users with their biddings);

If Auction Hoster, can end the auction ( calls endAuction function web3)
Cant bid if auction ended

Host can see email of top 2 bidders and email the people to verified through offline means, Exchange page accessed

---Exchange page---
Auction Hoster and bidder
each confirm twice
transactions proceeds








Database working:
needed for auction : nftAddress, auction title, auction description, hosted by, bidStartAmount
needed for biddings : nftAddress, (bidderAddress, bidAmount)[] ( array of bidders and their amount)
needed for emails : userAddress, email