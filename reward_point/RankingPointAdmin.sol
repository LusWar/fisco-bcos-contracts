pragma solidity ^0.4.25;

import "./BasicAuth.sol";
import "./RankingPointController.sol";
import "./RewardPointData.sol";

contract RankingPointAdmin is BasicAuth {
    address public _dataAddress;
    address public _controllerAddress;

    constructor() public {
        RewardPointData data = new RewardPointData("Ranking Points");
        _dataAddress = address(data);
        RankingPointController controller = new RankingPointController(_dataAddress);
        _controllerAddress = address(controller);
        data.upgradeVersion(_controllerAddress);
        data.addIssuer(msg.sender);
    }

    function upgradeVersion(address newVersion) public {
        _controllerAddress = newVersion;
        RewardPointData data = RewardPointData(_dataAddress);
        data.upgradeVersion(newVersion);
    }
}
