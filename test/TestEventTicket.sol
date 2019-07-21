pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EventTickets.sol";
import "../contracts/EventTicketsV2.sol";

contract TestEventTicket {

    uint public initialBalance = 1000000000;

    function() external payable { }

    function testConstructorSetCorrectOwner() public {

      EventTickets eventTickets = new EventTickets("Concert", "http://concert.eventbrite.com", 999 );
      (,,,,bool isOpen) = eventTickets.readEvent();
      Assert.isTrue(isOpen, "sales should be open when the contract is created");
    }

    function testShouldBeAbletoBuyTicketWhenEventIsOpen() public {

      EventTickets eventTickets = new EventTickets("Concert", "http://concert.eventbrite.com", 999 );
      eventTickets.buyTickets.value(100)(1);
      (,,,uint sales,) = eventTickets.readEvent();
      Assert.equal(sales, 1, "the ticket sales should be 1");
    }

    function testProvideEventIdShouldReturnCorrectEventDetails() public {
        EventTicketsV2 eventTicketsV2 = new EventTicketsV2();
        eventTicketsV2.addEvent("Concert", "http://concert.eventbrite.com", 999);
        (string memory description, string memory website, uint totalTickets, uint sales, bool isOpen)
         = eventTicketsV2.readEvent(0);
        Assert.equal(description, "Concert", "the event descriptions should match");
        Assert.equal(website, "http://concert.eventbrite.com", "the event website should match");
        Assert.equal(totalTickets, 999, "the event totalTickets should match");
        Assert.equal(sales, 0, "the event sales should match");
        Assert.equal(isOpen, true, "the event isOpen should match");
    }

    function testProvideEventIdToGetBuyerNumberTicketsShouldReturnTicketsPurchased() public {
        EventTicketsV2 eventTicketsV2 = new EventTicketsV2();
        eventTicketsV2.addEvent("Concert", "http://concert.eventbrite.com", 999);
        eventTicketsV2.buyTickets.value(300 * 3)(0, 3);
        uint count = eventTicketsV2.getBuyerNumberTickets(0);
        Assert.equal(count, 3, "Buyer should own 3 tickets");
    }
}