// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MusicStreaming {
    struct Song {
        uint256 id;
        address artist;
        string title;
        string artistName;
        string ipfsHash; // IPFS hash for the music file
        uint256 streamCount;
    }

    uint256 public songCount;
    mapping(uint256 => Song) public songs;
    mapping(address => uint256) public artistEarnings;
    mapping(address => uint256) public userSubscriptions;

    uint256 public subscriptionPrice = 0.01 ether; // Monthly subscription price
    uint256 public totalRevenue; // Total subscription revenue
    uint256 public totalStreams; // Total streams across all songs

    event SongUploaded(uint256 id, address artist, string title, string ipfsHash);
    event SongStreamed(uint256 id, address listener);
    event UserSubscribed(address user, uint256 expiration);

    function uploadSong(string memory _title, string memory _artistName, string memory _ipfsHash) public {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_ipfsHash).length > 0, "IPFS hash cannot be empty");

        songCount++;
        songs[songCount] = Song({
            id: songCount,
            artist: msg.sender,
            title: _title,
            artistName: _artistName,
            ipfsHash: _ipfsHash,
            streamCount: 0
        });

        emit SongUploaded(songCount, msg.sender, _title, _ipfsHash);
    }

    function subscribe() public payable {
        require(msg.value >= subscriptionPrice, "Insufficient payment");
        require(block.timestamp > userSubscriptions[msg.sender], "Subscription still active");

        userSubscriptions[msg.sender] = block.timestamp + 30 days; // 1-month subscription
        totalRevenue += msg.value;

        emit UserSubscribed(msg.sender, userSubscriptions[msg.sender]);
    }

    function streamSong(uint256 _songId) public {
        require(userSubscriptions[msg.sender] >= block.timestamp, "Subscription expired");

        Song storage song = songs[_songId];
        song.streamCount++;
        totalStreams++;

        emit SongStreamed(_songId, msg.sender);
    }

    function withdrawEarnings() public {
        uint256 earnings = (artistEarnings[msg.sender] * totalRevenue) / totalStreams;
        require(earnings > 0, "No earnings to withdraw");

        artistEarnings[msg.sender] = 0;
        payable(msg.sender).transfer(earnings);
    }
}