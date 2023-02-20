//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MiracleNFT is ERC721{
    using Counters for Counters.Counter;
    //gives us access to counter
    Counters.Counter public articleIdCounter;

    mapping(uint256 => Article) public articles;

    mapping(address => string) writer_name;

    struct Article {
        uint256 id;
        address payable writer;
        string title;
        string cid;
        uint256 tipAmount;
    }

    event ArticlePublished(
        uint8 id
    );

    event ArticleTipped(
        uint8 id
    );

    constructor() ERC721("Perspective", "PA") public {
    }

    function awardItem(address player, string memory tokenURI) public returns (uint256) {
        articleIdCounter.increment();

        uint256 newItemId = articleIdCounter.current();
        _mint(player, newItemId);
        //_setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function mapGetter(uint256 id) public view returns(Article memory) 
    {
        return articles[id];
    }

    function publishArticle(string memory _ipfsCID, string memory _title) public {
        // Make sure article title exists
        require(bytes(_title).length > 0); 
        // Make sure uploader address exists
        require(msg.sender!=address(0));

        // Increment image id
        uint256 articleId = articleIdCounter.current(); //getting current count
        articleIdCounter.increment(); //incrementing after use

        //add article to the contract
        articles[articleId] = Article(
            articleId,
            payable(msg.sender),
            _title,
            _ipfsCID,
            0
        );
        // Trigger an event
        emit ArticlePublished(1);
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
}
