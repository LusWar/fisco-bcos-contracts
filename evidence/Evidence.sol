pragma solidity ^0.4.4;

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
    event errorNewSignaturesEvent(string evi, string info, uint8 v, bytes32 r, bytes32 s, address addr);
    event errorAddSignaturesEvent(string evi, string info, uint8 v, bytes32 r, bytes32 s, address addr);
    event addRepeatSignaturesEvent(string evi, string info, uint8 v, bytes32 r, bytes32 s);
    event errorRepeatSignaturesEvent(string evi, uint8 v, bytes32 r, bytes32 s, address addr);

    function CallVerify(address addr) public constant returns (bool) {
        return EvidenceSignersDataABI(factoryAddr).verifySigner(addr);
    }

   constructor(string evi, string info, uint8 v, bytes32 r, bytes32 s, address addr)  {
       factoryAddr = addr;
       if(CallVerify(tx.origin))
       {
           evidence = evi;
           evidenceInfo = info;
           _v.push(v);
           _r.push(r);
           _s.push(s);
           evidenceSigners.push(tx.origin);
           emit newSignaturesEvent(evi, info, v, r, s, addr);
       }
       else
       {
           emit errorNewSignaturesEvent(evi, info, v, r, s, addr);
       }
    }

    function getEvidence() public constant returns (string, string, uint8[], bytes32[], bytes32[], address[], address[]) {
        uint length = EvidenceSignersDataABI(factoryAddr).getSignersSize();
         address[] memory signerList = new address[](length);
         for(uint i= 0 ;i<length ;i++)
         {
             signerList[i] = (EvidenceSignersDataABI(factoryAddr).getSigner(i));
         }
        return(evidence, evidenceInfo, _v, _r, _s, evidenceSigners, signerList);
    }

    function addSignature(uint8 v, bytes32 r, bytes32 s) public returns (bool) {
        for(uint i= 0 ;i<evidenceSigners.length ;i++)
        {
            if(tx.origin == evidenceSigners[i])
            {
                if(_v[i] == v && _r[i] == r && _s[i] == s) {
                    emit addSignaturesEvent(evidence, evidenceInfo, v, r, s);
                    return true;
                }
            }
        }
       if(CallVerify(tx.origin))
       {
           _v.push(v);
           _r.push(r);
           _s.push(s);
           evidenceSigners.push(tx.origin);
           emit addSignaturesEvent(evidence, evidenceInfo, v, r, s);
           return true;
       }
       else
       {
           emit errorAddSignaturesEvent(evidence, evidenceInfo, v, r, s, tx.origin);
           return false;
       }
    }

    function getEvidenceSigners() public view returns (address[]) {
        return evidenceSigners;
    }

    function getSigners() public view returns (address[]) {
         uint length = EvidenceSignersDataABI(factoryAddr).getSignersSize();
         address[] memory signerList = new address[](length);
         for(uint i= 0 ;i<length ;i++)
         {
             signerList[i] = (EvidenceSignersDataABI(factoryAddr).getSigner(i));
         }
         return signerList;
    }
}
