//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BlogChain is ERC721URIStorage {
    using Counters for Counters.Counter;
    //gives us access to counter
    Counters.Counter public articleIdCounter;

    mapping(uint256 => Article) public articles;

    mapping(address => string) writer_name;

    struct Article {
        uint256 id;
        address payable writer;
        string title;
        uint256 tipAmount;
    }

    constructor() ERC721("BlogChainNFT", "BLOGNFT") {}
    
    function mapGetter(uint256 id) public view returns(Article memory){
        return articles[id];
    }
    
    function publishArticle(string memory _ipfsCID, string memory _title) public {
        // Make sure article title exists
        require(bytes(_title).length > 0); 
        // Make sure uploader address exists
        require(msg.sender!=address(0));

        // Increment article id
        uint256 articleId = articleIdCounter.current(); //getting current count
        articleIdCounter.increment(); //incrementing after use

        //add article to the contract
        articles[articleId] = Article(
            articleId,
            payable(msg.sender),
            _title,
            0
        );

        // Mint NFT for article
        _safeMint(msg.sender, articleId);
        _setTokenURI(articleId, _ipfsCID);
    }

    function tipWriter(uint256 _id,uint256 _amount) public payable {
        require(_id <= articleIdCounter.current());
        
        //get the article
        Article memory _article = articles[_id];

        //add the tipamount
        _article.tipAmount = _article.tipAmount + _amount;

        //update the article info
        articles[_id] = _article;
    }
}
