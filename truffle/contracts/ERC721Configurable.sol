// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

abstract contract ERC721Configurable is ERC721 {
    // map of tokenId => interactiveConfURI.
    mapping(uint256 => string) private _interactiveConfURIs;

    function _setInteractiveConfURI(
        uint256 tokenId,
        string calldata _interactiveConfURI
    ) internal virtual {
        require(
            _exists(tokenId),
            "ERC721Configurable: Configuration URI for unknown token"
        );
        _interactiveConfURIs[tokenId] = _interactiveConfURI;
    }

    /**
     * Configuration uri for tokenId
     */
    function interactiveConfURI(uint256 tokenId)
        public
        virtual
        view
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Configurable: Configuration URI query for unknown token"
        );
        return _interactiveConfURIs[tokenId];
    }
}
