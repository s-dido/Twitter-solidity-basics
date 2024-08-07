// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Twitter{

    address public owner;
    uint256 public TWEET_MAX_LENGTH = 280;
    
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    constructor(){
        owner = msg.sender;
    }

    mapping ( address => Tweet[] ) tweets;

    event TweetCreated(uint256 id, address author, string content, uint256 timestamp, uint256 likes);
    event TweetLiked (address liker, address tweetAuthot, uint256 id, uint256 newLikeCount);
    event TweetUnLiked (address unLiker, address tweetAuthot, uint256 id, uint256 newLikeCount);

    function createTweet(string memory _tweet) public {
        
        require ( bytes(_tweet).length <= TWEET_MAX_LENGTH, "tweet is to long");

        Tweet memory newTweet = Tweet({
        id: tweets[msg.sender].length,
        author: msg.sender,
        content: _tweet,
        timestamp: block.timestamp,
        likes: 0

        });
            tweets[msg.sender].push(newTweet); 

            emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp, newTweet.likes);   
        }

        function likeTweet (address author, uint256 id) external  {
            
            require(tweets[author][id].id == id, "Tweet does not exist");
             tweets[author][id].likes++;
        
            emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
        }

        function unLikeTweet(address author, uint256 id) external {
            
            require(tweets[author][id].likes > 0 && tweets[author][id].id == id, "This tweet has no have likes or does not exist");
            tweets[author][id].likes--;

            emit TweetUnLiked(msg.sender, author, id, tweets[author][id].likes);
        } 


        modifier onlyOwner(){
            require(msg.sender == owner, "ONLY THE OWNER CAN DO THIS");
            _;
        }

        function changeTweetLength (uint256 _newTweetLength) public onlyOwner {
            TWEET_MAX_LENGTH = _newTweetLength;
        }

        function getTweet ( uint _i) public view returns (Tweet memory){
            return tweets[msg.sender][_i];
        }   

         function getAllTweets (address _owner) public view returns (Tweet[] memory){
            return tweets[_owner];
        }


}
