// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {

    uint256 totalWaveCount;
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    mapping(address => uint) public lastWavedAt;

    constructor() payable {
        console.log("Heyo! I am a smart contract :)");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {

        require(lastWavedAt[msg.sender] + 1 minutes < block.timestamp, "Please wait a minute before waving again!");

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaveCount += 1;
        console.log("%s has just waved!", msg.sender);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        // reset to generate new seed for the next wave
        seed = (block.timestamp + block.difficulty) % 100;
        console.log("Random # generated: %d", seed);

        if(seed <= 50) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.005 ether;

            require(prizeAmount <= address(this).balance, "Trying to withdraw more $ than the contract has!");
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw $ from the contract.");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns(Wave[] memory) {
        return waves;
    }

    function getTotalWaveCount() public view returns(uint256) {
        return totalWaveCount;
    }
}

