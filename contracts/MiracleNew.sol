//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
//store metadata
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MiracleNew is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    //gives us access to counter
    Counters.Counter public articleIdCounter;
    uint256 public fee;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _fee
    ) ERC721(_name, _symbol) {
        fee = _fee;
    }

    mapping(uint256 => Article) public articles;

    mapping(address => string) writer_name;

    struct Article {
        uint256 id;
        address payable writer;
        string title;
        string tokenUri;
        uint256 tipAmount;
    }

    event ArticlePublished(
        uint8 id
    );

    event ArticleTipped(
        uint8 id
    );

    function mapGetter(uint256 id) public view returns(Article memory) 
    {
        return articles[id];
    }

    // function upload(string memory _title) public payable{
    //     safeMint(_title, msg.sender, tokenUri);
    // }
    //uri - where the metadata for the token will be stored
    function safeMint(
        string memory _title,
        address to,
        string memory tokenUri
    ) public payable {
        //check if the uri is there
        require(bytes(tokenUri).length > 0);
        //ensure that title is not null
        require(bytes(_title).length > 0);
        //ensure that the address is valid
        require(msg.sender != address(0));
        // require(msg.value >= fee, "Not enough fee!!");
        // //transferring fee
        // payable(owner()).transfer(fee);

        uint256 articleId = articleIdCounter.current(); //getting current count
        articleIdCounter.increment(); //incrementing after use
        
        //add article to the contract
        articles[articleId] = Article(
            articleId,
            payable(msg.sender),
            _title,
            tokenUri,
            0
        );
        
        //trigger an event
        emit ArticlePublished(0);

        //minting the token
        _safeMint(to, articleId);

        //setting the token uri to the one sent to the fn
        _setTokenURI(articleId, tokenUri);

        //returing the excess fee
        uint256 contractBalance = address(this).balance;
        if (contractBalance > 0) {
            payable(msg.sender).transfer(address(this).balance);
        }
    }

    function tipWriter(uint256 _id) public payable {
        require(_id > 0 && _id <= articleIdCounter.current());
        //get the article
        Article memory _article = articles[_id];
        //get the writer address
        address payable _writer = _article.writer;
        //pay the writer
        _writer.transfer(msg.value);
        _article.tipAmount = _article.tipAmount + msg.value;
        //update the article info
        articles[_id] = _article;
        emit ArticleTipped(1);
    }

    //override functions
    function _burn(uint256 articleId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(articleId);
    }

    function tokenURI(uint256 articleId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(articleId);
    }
}