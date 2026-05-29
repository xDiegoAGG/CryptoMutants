// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/*
 * @title  CryptoMutants
 * @notice ERC-721 collection of 12 unique mutants, inspired by the
 *         Mutants: Genetic Gladiators game and the original CryptoKitties.
 * @by     Diego
 */

contract CryptoMutants is ERC721, Ownable {
    using Strings for uint256;

    // Types

    /// The 4 possible genes a mutant can carry.
    enum Gene {
        Cyber,
        Sable,
        Mitico,
        Galactico
    }

    /// Base stats associated with a single gene.
    struct GeneStats {
        uint16 hp;
        uint16 attack;
        uint16 speed;
    }

    /// @notice On-chain representation of a single mutant.
    struct Mutant {
        string name;
        Gene primary;
        Gene secondary;
        uint16 hp;
        uint16 attack;
        uint16 speed; // stored * 100
    }

    
    // State

    uint256 public constant TOTAL_SUPPLY = 12;
    string private _baseTokenURI;
    mapping(uint256 => GeneStats) private _geneStats;
    mapping(uint256 => Mutant) public mutants;
    mapping(address => bool) public hasMinted;

    // Events

    event MutantMinted(
        address indexed minter,
        uint256 indexed tokenId,
        string name
    );

    event BaseURIUpdated(string newBaseURI);

    // Construction

    constructor(string memory baseURI_)
        ERC721("CryptoMutants", "MGG")
        Ownable(msg.sender)
    {
        _baseTokenURI = baseURI_;

        // gene base modifiers.
        _geneStats[uint256(Gene.Cyber)]     = GeneStats(1837, 271, 400);
        _geneStats[uint256(Gene.Sable)]     = GeneStats(1516, 380, 556);
        _geneStats[uint256(Gene.Mitico)]    = GeneStats(1659, 451, 476);
        _geneStats[uint256(Gene.Galactico)] = GeneStats(1049, 165, 1111);

        // The 12 ordered gene pairs and their names.

        _registerMutant(1,  "Dezinger",      Gene.Cyber,     Gene.Sable);
        _registerMutant(2,  "Autonoraptor",  Gene.Cyber,     Gene.Mitico);
        _registerMutant(3,  "Invadron",      Gene.Cyber,     Gene.Galactico);
        _registerMutant(4,  "Ejecutor",      Gene.Sable,     Gene.Cyber);
        _registerMutant(5,  "Valkiria",      Gene.Sable,     Gene.Mitico);
        _registerMutant(6,  "Geminium",      Gene.Sable,     Gene.Galactico);
        _registerMutant(7,  "Tecno Tao",     Gene.Mitico,    Gene.Cyber);
        _registerMutant(8,  "Oriax",         Gene.Mitico,    Gene.Sable);
        _registerMutant(9,  "Cthlig",        Gene.Mitico,    Gene.Galactico);
        _registerMutant(10, "Aniquilador",   Gene.Galactico, Gene.Cyber);
        _registerMutant(11, "Sundance Bug",  Gene.Galactico, Gene.Sable);
        _registerMutant(12, "Nebulon",       Gene.Galactico, Gene.Mitico);
    }

    // Utilities
    
    function _registerMutant(
        uint256 tokenId,
        string memory name_,
        Gene primary,
        Gene secondary
    ) internal {
        GeneStats memory p = _geneStats[uint256(primary)];
        GeneStats memory s = _geneStats[uint256(secondary)];

        mutants[tokenId] = Mutant({
            name: name_,
            primary: primary,
            secondary: secondary,
            hp:     p.hp     + s.hp     / 2,
            attack: p.attack + s.attack / 2,
            speed:  p.speed  + s.speed  / 2
        });
    }

    /// @inheritdoc ERC721
    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    // Public mint

    /**
     * @notice Claim a specific mutant for the caller, by token ID.
     * @dev    Free public mint with two restrictions:
     *           - the caller must not have minted before, and
     *           - the requested mutant must not have been claimed yet.
     *         After the initial mint, secondary-market transfers are
     *         unrestricted: a wallet can hold multiple mutants if it
     *         buys/receives them from another holder.
     * @param  tokenId The mutant ID to claim, in [1, TOTAL_SUPPLY].
     */

    function mint(uint256 tokenId) external {
        require(
            tokenId >= 1 && tokenId <= TOTAL_SUPPLY,
            "Invalid mutant ID"
        );
        require(
            !hasMinted[msg.sender],
            "Wallet has already minted a mutant"
        );
        require(
            _ownerOf(tokenId) == address(0),
            "Mutant already claimed"
        );

        hasMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId);

        emit MutantMinted(msg.sender, tokenId, mutants[tokenId].name);
    }


    // Owner-only admin

    function setBaseURI(string calldata newBaseURI) external onlyOwner {
        _baseTokenURI = newBaseURI;
        emit BaseURIUpdated(newBaseURI);
    }

    // Views

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        _requireOwned(tokenId);
        string memory base = _baseURI();
        return bytes(base).length == 0
            ? ""
            : string(abi.encodePacked(base, tokenId.toString(), ".json"));
    }

    function getMutant(uint256 tokenId)
        external
        view
        returns (Mutant memory)
    {
        require(
            tokenId >= 1 && tokenId <= TOTAL_SUPPLY,
            "Invalid mutant ID"
        );
        return mutants[tokenId];
    }

    function availableMutants() external view returns (uint256[] memory) {
        uint256[] memory buffer = new uint256[](TOTAL_SUPPLY);
        uint256 count;
        for (uint256 i = 1; i <= TOTAL_SUPPLY; i++) {
            if (_ownerOf(i) == address(0)) {
                buffer[count++] = i;
            }
        }

        uint256[] memory available = new uint256[](count);
        for (uint256 j = 0; j < count; j++) {
            available[j] = buffer[j];
        }
        return available;
    }
}