// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ERC721Configurable.sol";

contract InteractiveNFT is Ownable, ERC721Configurable {
    constructor() public ERC721("InteractiveNFT", "INFT") {}

    /**
     * Mint a token to _to
     */
    function mint(
        uint256 _tokenId,
        address _to,
        string calldata _tokenURI
    ) public {
        _safeMint(_to, _tokenId);
        _setTokenURI(_tokenId, _tokenURI);
    }

    /**
     * Mint a token to _to with a _interactiveConfURI already set
     */
    function mint(
        uint256 _tokenId,
        address _to,
        string calldata _tokenURI,
        string calldata _interactiveConfURI
    ) public {
        _safeMint(_to, _tokenId);
        _setTokenURI(_tokenId, _tokenURI);
        _setInteractiveConfURI(_tokenId, _interactiveConfURI);
    }

    /**
        Function to let Owner set configurationURI
     */
    function setInteractiveConfURI(
        uint256 _tokenId,
        string calldata _interactiveConfURI
    ) public {
        require(
            _isApprovedOrOwner(_msgSender(), _tokenId),
            "ERC721Configurable: Operator is not approved"
        );
        _setInteractiveConfURI(_tokenId, _interactiveConfURI);
    }
}
