pragma solidity ^0.4.25;

import "./BasicAuth.sol";
import "./ConsumptionPointController.sol";
import "./RewardPointData.sol";

contract ConsumptionPointAdmin is BasicAuth {
    address public _dataAddress;
    address public _controllerAddress;

    constructor() public {
        RewardPointData data = new RewardPointData("Consumption Points");
        _dataAddress = address(data);
        ConsumptionPointController controller = new ConsumptionPointController(_dataAddress);
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
