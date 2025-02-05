// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Counter {
    // State variable
    uint256 public count;

    // Event
    event Incremented(address indexed sender, uint256 newCount, string message);

    function getCount() public view returns (uint256) {
        return count;
    }

    function setCounter(uint256 count_) public {
        count = count_;
    }

    function increment() public {
        uint256 maxValue = uncheckedValue();
        if (count < maxValue) {
            count++;
        }

        emit Incremented(msg.sender, count, "Counter incremented failed!");
    }

    function decrement() public {
        require(count != 0);
        count--;
    }

    function increase_by_value(uint256 _value) public  {
        unchecked {
            uint256 maxValue = uncheckedValue();

            uint256 newCount = count + _value;
            if (newCount > maxValue) {
                revert("Value is greater than maxValue");
            }

            if (newCount < maxValue) {
                count = newCount;
            }
        }
    }

    function decrease_by_value(uint256 _value) public {
        if (count > _value) {
            count += _value;
        }
    }

    function uncheckedValue() public pure returns (uint256) {
        unchecked {
            return uint256(0) - 1;
        }
    }
}


