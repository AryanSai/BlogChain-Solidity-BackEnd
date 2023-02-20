//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Greet {
  string public message;
  
  constructor () {
    message = "Hello, There";
  }

  function setMessage (string memory _message) public {
    message = _message;
  }

}