// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FruitNinja {
    enum ObjectType { None, Fruit, Bomb }

    struct Game {
        uint score;
        bool isGameOver;
    }

    mapping(address => Game) public games;

    event Sliced(address indexed player, ObjectType object, uint score);
    event GameRestarted(address indexed player);

    /// @notice Slice an object (fruit or bomb)
    function slice() external {
        require(!games[msg.sender].isGameOver, "Game over. Restart to play again.");

        ObjectType object = _randomObject();

        if (object == ObjectType.Fruit) {
            games[msg.sender].score += 1;
        } else {
            games[msg.sender].isGameOver = true;
        }

        emit Sliced(msg.sender, object, games[msg.sender].score);
    }

    /// @notice Restart the game after game over
    function restart() external {
        games[msg.sender] = Game(0, false);
        emit GameRestarted(msg.sender);
    }

    /// @notice View your current score
    function getMyScore() external view returns (uint) {
        return games[msg.sender].score;
    }

    /// @notice View game status
    function isGameOver() external view returns (bool) {
        return games[msg.sender].isGameOver;
    }

    /// @dev Simulate randomness (not secure, for fun use only)
    function _randomObject() private view returns (ObjectType) {
        uint rand = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 10;
        if (rand < 8) {
            return ObjectType.Fruit;
        } else {
            return ObjectType.Bomb;
        }
    }
}
