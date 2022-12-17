pragma solidity ^0.8.17;

contract TicketSale {

    // <contract_variables>
    
    address private owner;
    mapping (address => uint) tickets;
    mapping (uint => address) ticketsSold;
    uint ticketCount;
    uint private ticketPrice;
    mapping (address => address) swapOffers;
    
    // </contract_variables>

    constructor(uint numTickets, uint price) {
        ticketCount = numTickets;
        owner = msg.sender;
        ticketPrice = price;
    }

    function buyTicket(uint ticketId) public payable  returns (string memory, bool, bytes memory) {
        string memory message;
        bool success;
        bytes memory data;
        require(ticketId >= 1 && ticketId <= ticketCount); // valid identifier
        require(ticketsSold[ticketId] == address(0)); // not sold yet
        require(tickets[msg.sender] == 0); // no ticket
        require(msg.value == ticketPrice); // correct amount of Ether
        (success, data)= owner.call{value: ticketPrice}("");
        tickets[msg.sender] = ticketId;
        ticketsSold[ticketId] = msg.sender;
        return(message,success,data);
    }

    function getTicketOf(address person) public view returns (uint
    ) {
        return tickets[person];
    }

    function offerSwap(address partner) public {
        require(tickets[msg.sender] > 0); // sender has ticket
        require(partner != msg.sender); // partner is not sender
        swapOffers[msg.sender] = partner;
    }

    function acceptSwap(address partner) public {
        require(tickets[msg.sender] > 0); // sender has a ticket
        require(swapOffers[partner] == msg.sender); // partner wants to swap with sender
        (tickets[msg.sender], tickets[partner]) = (tickets[partner], tickets[msg.sender]); // swap
        ticketsSold[tickets[msg.sender]] = msg.sender;
        ticketsSold[tickets[partner]] = partner;
        swapOffers[partner] = address(0);
    }

}