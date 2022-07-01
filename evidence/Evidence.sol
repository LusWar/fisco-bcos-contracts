pragma solidity ^0.4.25;

contract EvidenceSignersDataABI
{
    function verifySigner(address addr)public constant returns(bool){}
    function getSigner(uint index)public constant returns(address){}
    function getSignersSize() public constant returns(uint){}
}

contract Evidence{

    string evidence;
    string evidenceInfo;
    uint8[] _v;
    bytes32[] _r;
    bytes32[] _s;
    address[] evidenceSigners;
    address public factoryAddr;

    event addSignaturesEvent(string evi, string info, uint8 v, bytes32 r, bytes32 s);
    event newSignaturesEvent(string evi, string info, uint8 v, bytes32 r, bytes32 s, address addr);
    event addRepeatSignaturesEvent(string evi, string info, uint8 v, bytes32 r, bytes32 s);

    function callVerify(address addr) internal view returns (bool) {
        return EvidenceSignersDataABI(factoryAddr).verifySigner(addr);
    }

    constructor(string evi, string info, uint8 v, bytes32 r, bytes32 s, address addr)  {
        factoryAddr = addr;
        require(callVerify(tx.origin), "No permission to create an evidence");
        evidence = evi;
        evidenceInfo = info;
        _v.push(v);
        _r.push(r);
        _s.push(s);
        evidenceSigners.push(tx.origin);
        emit newSignaturesEvent(evi, info, v, r, s, addr);
    }

    function getEvidence() public view returns (string, string, uint8[], bytes32[], bytes32[], address[], address[]) {
        uint length = EvidenceSignersDataABI(factoryAddr).getSignersSize();
        address[] memory signerList = new address[](length);
        for(uint i= 0 ;i<length ;i++)
        {
            signerList[i] = (EvidenceSignersDataABI(factoryAddr).getSigner(i));
        }
        return(evidence, evidenceInfo, _v, _r, _s, evidenceSigners, signerList);
    }

    function addSignature(uint8 v, bytes32 r, bytes32 s) public returns (bool) {
        for(uint i = 0; i < evidenceSigners.length; ++i)
        {
            if(tx.origin == evidenceSigners[i])
            {
                if(_v[i] == v && _r[i] == r && _s[i] == s) {
                    emit addSignaturesEvent(evidence, evidenceInfo, v, r, s);
                    return true;
                }
            }
        }
        require(callVerify(tx.origin), "No permission to add a signature");
        _v.push(v);
        _r.push(r);
        _s.push(s);
        evidenceSigners.push(tx.origin);
        emit addSignaturesEvent(evidence, evidenceInfo, v, r, s);
        return true;
    }

    function getEvidenceSigners() public view returns (address[]) {
        return evidenceSigners;
    }

    function getSigners() public view returns (address[]) {
        uint length = EvidenceSignersDataABI(factoryAddr).getSignersSize();
        address[] memory signerList = new address[](length);
        for(uint i = 0; i < length; ++i)
        {
            signerList[i] = (EvidenceSignersDataABI(factoryAddr).getSigner(i));
        }
        return signerList;
    }
}
