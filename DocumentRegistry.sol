// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DocumentRegistry {
    struct Document {
        bytes32 hash;
        uint256 timestamp;
        address owner;
        string documentType;
    }
    
    mapping(bytes32 => Document) private documents;
    mapping(address => bytes32[]) private userDocuments;
    
    event DocumentRegistered(bytes32 indexed docHash, address indexed owner, uint256 timestamp);
    event DocumentVerified(bytes32 indexed docHash, bool isValid);
    
    function registerDocument(bytes32 _docHash, string memory _documentType) external {
        require(documents[_docHash].timestamp == 0, "Document already registered");
        
        documents[_docHash] = Document({
            hash: _docHash,
            timestamp: block.timestamp,
            owner: msg.sender,
            documentType: _documentType
        });
        
        userDocuments[msg.sender].push(_docHash);
        emit DocumentRegistered(_docHash, msg.sender, block.timestamp);
    }
    
// Updated verifyDocument function
function verifyDocument(bytes32 _docHash) external view returns (
    bool exists, 
    uint256 timestamp, 
    address owner, 
    string memory docType
) {
    Document memory doc = documents[_docHash];
    exists = doc.timestamp != 0;
    timestamp = doc.timestamp;
    owner = doc.owner;
    docType = doc.documentType;
}
    
    function getUserDocuments() external view returns (bytes32[] memory) {
        return userDocuments[msg.sender];
    }
    
    // Helper function to calculate hash in Solidity (for demonstration)
    function calculateHash(string memory _content) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_content));
    }
}