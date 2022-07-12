pragma solidity ^0.4.25;

contract Evidence{

    string evidence;
    string evidenceInfo;
    string evidenceID;
    uint8[] _v;
    bytes32[] _r;
    bytes32[] _s;
    address[] evidenceSigners;
    address public factoryAddr;

    event addSignaturesEvent(string evi, string info, string id, uint8 v, bytes32 r, bytes32 s, address signer);
    event newSignaturesEvent(string evi, string info, string id, uint8 v, bytes32 r, bytes32 s, address signer);
    event addRepeatSignaturesEvent(string evi, string info, string id, uint8 v, bytes32 r, bytes32 s, address signer);

    constructor(string evi, string info, string id, uint8 v, bytes32 r, bytes32 s, address signer, address addr)  {
        require(signer != address(0x0), "Invalid signer address");
        require(addr != address(0x0), "Invalid factory address");
        evidence = evi;
        evidenceInfo = info;
        evidenceID = id;
        _v.push(v);
        _r.push(r);
        _s.push(s);
        evidenceSigners.push(signer);
        factoryAddr = addr;
        emit newSignaturesEvent(evi, info, id, v, r, s, signer);
    }

    function getEvidence() public view returns (string, string, string, uint8[], bytes32[], bytes32[], address[]) {
        return(evidence, evidenceInfo, evidenceID, _v, _r, _s, evidenceSigners);
    }

    function addSignature(uint8 v, bytes32 r, bytes32 s, address signer) public returns (bool) {
        require(signer != address(0x0), "Invalid signer address");
        for(uint i = 0; i < evidenceSigners.length; ++i)
        {
            if(signer == evidenceSigners[i])
            {
                if(_v[i] == v && _r[i] == r && _s[i] == s) {
                    emit addRepeatSignaturesEvent(evidence, evidenceInfo, evidenceID, v, r, s, signer);
                    return true;
                }
            }
        }
        _v.push(v);
        _r.push(r);
        _s.push(s);
        evidenceSigners.push(signer);
        emit addSignaturesEvent(evidence, evidenceInfo, evidenceID, v, r, s, signer);
        return true;
    }

    function getEvidenceSigners() public view returns (address[]) {
        return evidenceSigners;
    }
}
