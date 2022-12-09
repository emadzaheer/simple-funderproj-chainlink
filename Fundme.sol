// SPDX-License-Identifier: MIT

//will only work with goerli network bec of the chain link oracle.
//get funds and withdraw funds
// set a minimum funds val in USD

//792416 current gas. 

pragma solidity ^0.8.8;

import "./PriceConverter.sol"; 


contract FundMe{
    using PriceConverter for uint256;
    
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "Owner Only");
        _;                                         //_ represents the rest of the code in the function modifier is attached to.
    }

    uint256 minimumUsd = 50 * 1e18;  //to convert to wei  
    address[] public funders;
    mapping(address => uint) public addressToAmountFunded;

    function fund() public payable {
        require ( msg.value.getConversionRate()  >= minimumUsd, "Insufficient funds" );   //solidity does not know usd so we need to convert
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }
    
    function withdraw() public {
        
        for(uint256 funderIndex = 0; funderIndex < funders.length ; funderIndex++ ){
            address funder = funders[ funderIndex ];                    //funders is an array of addresses. 
            addressToAmountFunded[funder] = 0; 
        }
        funders = new address[](0);                          //reset the array: arr = new type[](number of objects)

                                                                                                       //transfer: 
                                                                                                       //send:
        /*                                                                                               //call: 
        payable( msg.sender ).transfer(address(this).balance );   //transfer funds to the caller of this function.
                                                                 //msg.sender is a an address typecasted to payable address type              
        bool sendSuccess payable( msg.sender ).send(address(this).balance );      //send does not revert like transfer does.but returns a bool instead 
        require(sendSuccess, "send fail");                       //we manually revert using send 
    
        */                                            //call is a lower level function
        
        //(bool callSuccess, bytes memory dataReturned ) = payable( msg.sender ).call{ value: address(this).balance }(""); //call is used on functions so it returns two vars in the brackets and bytes objects are arrays so data returns are memory
        (bool callSuccess, ) = payable( msg.sender ).call{ value: address(this).balance }(""); //call is used on functions so it returns two vars in the brackets and bytes objects are arrays so data returns are memory
        require(callSuccess, "call failed");
    }


}
