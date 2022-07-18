// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Reddit {

    struct post {
        uint id;
        address author;
        string post;
        uint votes;
    }

    struct response {
        uint id;
        address author;
        string response;
    }

    uint currentIdPost;
    uint currentIdResponse;

    mapping(uint => post) allPosts;
    mapping(uint => mapping(uint => response)) allResponses;
    mapping(uint => uint) idResponses;
    mapping(address => mapping(uint => bool)) hasVoted;
    mapping(address => uint) timestampLastPost;

    function createPost(string memory _post) external {
        require(timestampLastPost[msg.sender] < block.timestamp - 30, "Wait 30 sec between posts");
        require(bytes(_post).length > 0, "Empty post");
        post memory thisPost = post(currentIdPost, msg.sender, _post, 0);
        allPosts[currentIdPost] = thisPost;
        currentIdPost++;
        timestampLastPost[msg.sender] = block.timestamp;
    }

    function createResponse(uint _postId, string memory _response) external {
        require(bytes(allPosts[_postId].post).length > 0, "Inexistant post");
        require(bytes(_response).length > 0, "Empty response");
        require(timestampLastPost[msg.sender] < block.timestamp - 30, "Wait 30 sec between posts");
        response memory thisResponse = response(currentIdResponse, msg.sender, _response);
        allResponses[_postId][idResponses[_postId]] = thisResponse;
        currentIdResponse++;
        idResponses[_postId]++;
        timestampLastPost[msg.sender] = block.timestamp;
    }

    function vote(uint _postId, uint8 _vote) external {
        require(bytes(allPosts[_postId].post).length > 0, "Inexistant post");
        require(_vote == 0 || _vote == 1, "Wrong vote");
        require(!hasVoted[msg.sender][_postId], "Already voted");
        require(allPosts[_postId].author != msg.sender, "Can't vote for your post");
        require(timestampLastPost[msg.sender] < block.timestamp - 30, "Wait 30 sec between posts");
        if (_vote == 0) {
            allPosts[_postId].votes--;
        } else {
            allPosts[_postId].votes++;
        }
        hasVoted[msg.sender][_postId] = true;
        timestampLastPost[msg.sender] = block.timestamp;
    }

    function getAllPost() external  view returns(post[] memory) {
        post[] memory posts = new post[](currentIdPost);
        for (uint i = 0; i < currentIdPost; i++) {
            posts[i] = allPosts[i];
        }
        return posts;
    }

    function getAllPostUser(address _user) external view returns(post[] memory) {
        uint size = 0;
        for (uint i = 0; i < currentIdPost; i++) {
            if (allPosts[i].author == _user) {
                size++;
            }
        }
        post[] memory posts = new post[](size);
        uint count = 0;
        for (uint i = 0; i < currentIdPost; i++) {
            if (allPosts[i].author == _user) {
                posts[count] = allPosts[i];
                count++;
            }
        }
        return posts;
    }

    function getResponsesPost(uint _postId) external view returns(response[] memory) {
        uint responseCount;
        for (uint i = 0; i < idResponses[_postId]; i++) {
            if (bytes(allResponses[_postId][i].response).length > 0) {
                responseCount++;
            }
        }
        response[] memory responses = new response[](responseCount);
        uint count = 0;
        for (uint i = 0; i < responseCount; i++) {
            responses[count] = allResponses[_postId][i];
            count++;
        }
        return responses;
    }
}