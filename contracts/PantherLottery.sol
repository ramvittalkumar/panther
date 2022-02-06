// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract PantherLottery is VRFConsumerBase {
    address public owner;
    address payable[] public participants;
    uint public lotteryId;
    mapping (uint => address payable) public lotteryHistory;

    bytes32 internal keyHash; // identifies which Chainlink oracle to use
    uint internal fee;        // fee to get random number
    uint public randomResult;

    constructor()
        VRFConsumerBase(
            0x8C7382F9D8f56b33781fE506E897a4F1e2d17255, // VRF coordinator for Polygon Mumbai testnet
            0x326C977E6efc84E512bB9C30f76E30c160eD06FB  // LINK token address for Polygon Mumbai testnet
        ) {
            keyHash = 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4;
            fee = 0.1 * 10 ** 18;    // 0.1 LINK

            owner = msg.sender;
            lotteryId = 1;
        }

    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK in contract");
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint randomness) internal override {
        randomResult = randomness;
    }

    function getWinnerByLottery(uint lottery) public view returns (address payable) {
        return lotteryHistory[lottery];
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getParticipants() public view returns (address payable[] memory) {
        return participants;
    }

    function enter() public payable {
        require(msg.value > .01 ether);

        // address of participants entering lottery
        participants.push(payable(msg.sender));
    }

    function pickWinner() public onlyowner {
        getRandomNumber();
    }

    modifier onlyowner() {
      require(msg.sender == owner);
      _;
    }
}