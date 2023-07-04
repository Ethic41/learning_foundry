// SPDX-License-Identifier: MIT
// -=-<[ Bismillahirrahmanirrahim ]>-=-
// -*- coding: utf-8 -*-
// @Date    : 2023-07-04 13:46:12
// @Author  : Dahir Muhammad Dahir (dahirmuhammad3@gmail.com)
pragma solidity 0.8.18;

contract Bank {
    mapping(address accountHolder => uint256 balance) public accountBalances;
    mapping(address accountHolder => bool record) public accountRecords;

    uint256 public minimumDeposit = 3_000 wei;
    uint256 public bankAccountsCount = 0;

    function createBankAccount() public {
        require(!accountRecords[msg.sender], "Bank Account already exist");
        accountBalances[msg.sender] = 0;
        accountRecords[msg.sender] = true;
        bankAccountsCount += 1;
    }

    function depositFunds() public payable {
        checkAccountExist(msg.sender);
        require(msg.value > minimumDeposit, "Deposit amount is too low");

        accountBalances[msg.sender] += msg.value;
    }

    function transferFunds(address targetAccount, uint256 amount) public {
        checkAccountExist(targetAccount);
        require(accountBalances[msg.sender] - amount >= minimumDeposit, "Insufficient Balance");

        accountBalances[msg.sender] -= amount;
        accountBalances[targetAccount] += amount;
    }

    function checkAccountExist(address account) internal view {
        require(accountRecords[account], "Account does not exist");
    }

    function checkSufficientBalance(address account, uint256 amount) internal view {
        require(accountBalances[account] - amount >= minimumDeposit, "Insufficient Balance");
    }

    function withdrawFunds(uint256 amount) public {
        checkSufficientBalance(msg.sender, amount);
        (bool success,) = payable(msg.sender).call{value: amount}("");
        require(success, "withdrawal failed");
    }

    function closeAccount() public {
        checkAccountExist(msg.sender);
        accountRecords[msg.sender] = false;
        accountBalances[msg.sender] = 0;
        (bool success,) = payable(msg.sender).call{value: accountBalances[msg.sender]}("");
        require(success, "failed to close failed");
    }
}
