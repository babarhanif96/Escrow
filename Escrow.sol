
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.7;
contract Escrow {


  

   struct trading {
       address  payable seller;
       address payable  buyer;
       uint256 value;

   }

    mapping(uint256 => trading) public trading_data ;
    enum State { AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE , CANCEL}
    State public currState;
    
    modifier onlySeller(uint256 _id) {
        require(msg.sender == trading_data[_id].seller, "Only seller can call this method");
        _;
    }
    

     function getSeller_Buyer(uint256 _id ,address payable _buyer, address payable  _seller) public {
         trading_data[_id].seller = _seller;
          trading_data[_id].buyer = _buyer;
       
    }
    function deposit(uint256 _id )  external payable {
         trading_data[_id].value = msg.value;
      

        currState = State.AWAITING_DELIVERY;
    }
    function confirmDelivery(uint256 _id )  onlySeller( _id) external {
     
         trading_data[_id].buyer.transfer(trading_data[_id].value);
        currState = State.COMPLETE;
    }
    function dispute_Delivery(uint256 _id )   external {
     
         trading_data[_id].seller.transfer(trading_data[_id].value);
        currState = State.CANCEL;
    }
}