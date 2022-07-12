pragma solidity ^0.4.25;

import "./RewardPointController.sol";

contract RankingPointController is RewardPointController {
    constructor(address dataAddress) RewardPointController(dataAddress) public {}
}
