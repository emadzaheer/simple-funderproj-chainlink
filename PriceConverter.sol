//SPDX-License-Identifier: MIT
//Library implementation. 
  //they can't have state variables and can't send ether.
    //all functions are internal. 
pragma solidity ^0.8.0;


import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
     //0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e  ETH/USD from chainlink price feed
                                                                /*
                                                                address of the imported contract =>      1:go to chain link datafeed(pricefeed) and see the network being used in by the V3aggregator interface.
                                                                                                    2: got to the ethereum addresses section and select the address of the commodity in the specified test network from part 1.  
                                                                //abi of that imported contract=>        3: note the address 
                                                                                                    4: the abi only has function names and interactions, not logic
                                                                                                    5: go to aggregatorV3.sol interface-compiling it will give the ABI
                                                                */ 
    


    function getPrice() internal view returns(uint256) {
                                                            
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);                                      
        (, int price,,,) = priceFeed.latestRoundData();         //leave empty slots for other values that are being returned
                                                                // returns 1200.00000000  has 8 decimal places
        return uint256(price * 1e10);                       //typecasting from int-->uint

        //Below line if you need all in the return statement
        //(uint80 roundId, int price, uint startedAt, uint timeStamp, uint80 answeredInRound ) = priceFeed.latestRoundData()
    }
    
    
    function getVersion() internal view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return priceFeed.version();                         //returns 4 as it is the 4th ver of pricefeed
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; 
        return ethAmountInUsd;
    }
    
}
