// Import dependencies
import { formatCurrency } from '../utils/format';

// Get references to HTML elements
const walletContainer = document.getElementById('wallet');
const balanceElement = document.getElementById('wallet-balance');
const transactionList = document.getElementById('transaction-list');
const depositButton = document.getElementById('deposit-button');
const withdrawButton = document.getElementById('withdraw-button');

// Initialize wallet state
let balance = 0;
let transactions = [];

// Function to fetch wallet data from API
async function fetchWalletData() {
  try {
    const response = await fetch('/api/wallet');
    const data = await response.json();
    balance = data.balance;
    transactions = data.transactions;
    updateWallet();
  } catch (error) {
    console.error(error);
  }
}

// Function to update wallet HTML elements
function updateWallet() {
  balanceElement.textContent = formatCurrency(balance);
  updateTransactionList();
}

// Function to update transaction list
function updateTransactionList() {
  const listHtml = '';
  transactions.forEach((transaction) => {
    listHtml += `
      <li>
        <span>${transaction.date}</span>
        <span>${formatCurrency(transaction.amount)}</span>
        <span>${transaction.type}</span>
      </li>
    `;
  });
  transactionList.innerHTML = listHtml;
}

// Function to handle deposit button click
depositButton.addEventListener('click', async () => {
  try {
    const amount = parseFloat(prompt('Enter deposit amount:'));
    if (amount > 0) {
      const response = await fetch('/api/deposit', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ amount })
      });
      const data = await response.json();
      balance += amount;
      updateWallet();
    }
  } catch (error) {
    console.error(error);
  }
});

// Function to handle withdraw button click
withdrawButton.addEventListener('click', async () => {
  try {
    const amount = parseFloat(prompt('Enter withdraw amount:'));
    if (amount > 0 && amount <= balance) {
      const response = await fetch('/api/withdraw', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ amount })
      });
      const data = await response.json();
      balance -= amount;
      updateWallet();
    }
  } catch (error) {
    console.error(error);
  }
});

// Initialize wallet
fetchWalletData();