// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

interface IERC20 {

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function totalSupply() external pure returns (uint64);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);
}

contract Waves is IERC20 {

    string public constant name = "Waves";
    string public constant symbol = "WAV";
    uint8 public constant decimals = 9;
    uint64 public constant totalSupply = 2_000_000_000_000_000;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private spenders;

    constructor() {
        balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function balanceOf(address owner) external view returns (uint256 balance) {
        return balances[owner];
    }

    function transfer(address to, uint256 value) external returns (bool success) {
        require(to != address(0), "Address zero");
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool success) {
        require(to != address(0), "Address zero");
        balances[from] -= value;
        spenders[from][msg.sender] -= value;
        balances[to] += value;
        emit Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 value) external returns (bool success) {
        spenders[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
    function allowance(address owner, address spender) external view returns (uint256 remaining) {
        return spenders[owner][spender];
    }

}