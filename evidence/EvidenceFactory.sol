pragma solidity ^0.4.25;
import "./Evidence.sol";

contract EvidenceFactory{
    address[] signers;

    event newEvidenceEvent(address addr);

    constructor(address[] evidenceSigners){
        for(uint i = 0; i < evidenceSigners.length; ++i) {
            signers.push(evidenceSigners[i]);
        }
    }

    function newEvidence(string evi, string info, uint8 v, bytes32 r, bytes32 s) public returns (address) {
        Evidence evidence = new Evidence(evi, info, v, r, s, this);
        emit newEvidenceEvent(evidence);
        return evidence;
    }

    function getEvidence(address addr) public view returns (string, string, uint8[], bytes32[], bytes32[], address[], address[]) {
        return Evidence(addr).getEvidence();
    }

    function addSignature(address addr, uint8 v, bytes32 r, bytes32 s) public returns (bool) {
        return Evidence(addr).addSignature(v, r, s);
    }

    function verifySigner(address addr)public view returns (bool) {
        for(uint i = 0; i < signers.length; ++i) {
            if (addr == signers[i])
            {
                return true;
            }
        }
        return false;
    }

    function getSigner(uint index)public view returns (address) {
        uint listSize = signers.length;
        require(index < listSize, "Wrong index");
        return signers[index];
    }

    function getSignersSize() public view returns (uint) {
        return signers.length;
    }

    function getSigners() public view returns (address[]) {
        return signers;
    }
}
