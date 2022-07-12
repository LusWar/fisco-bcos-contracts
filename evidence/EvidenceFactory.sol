pragma solidity ^0.4.25;
import "./Evidence.sol";

contract EvidenceFactory{

    event newEvidenceEvent(address addr);

    constructor(){}

    function newEvidence(string evi, string info, string id, uint8 v, bytes32 r, bytes32 s) public returns (address) {
        Evidence evidence = new Evidence(evi, info, id, v, r, s, msg.sender, this);
        emit newEvidenceEvent(evidence);
        return evidence;
    }

    function getEvidence(address addr)
    public view returns (string, string, string, uint8[], bytes32[], bytes32[], address[]) {
        require(addr != address(0x0), "Invalid evidence address");
        return Evidence(addr).getEvidence();
    }

    function addSignature(address addr, uint8 v, bytes32 r, bytes32 s) public returns (bool) {
        require(addr != address(0x0), "Invalid evidence address");
        return Evidence(addr).addSignature(v, r, s, msg.sender);
    }

}
