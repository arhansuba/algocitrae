// Import dependencies
import { Chart } from 'chart.js';
import { formatCurrency } from '../utils/format';

// Get references to HTML elements
const dashboardContainer = document.getElementById('dashboard');
const balanceElement = document.getElementById('balance');
const profitElement = document.getElementById('profit');
const chartContainer = document.getElementById('chart');

// Initialize dashboard state
let balance = 0;
let profit = 0;
let chartData = [];

// Function to fetch dashboard data from API
async function fetchDashboardData() {
  try {
    const response = await fetch('/api/dashboard');
    const data = await response.json();
    balance = data.balance;
    profit = data.profit;
    chartData = data.chartData;
    updateDashboard();
  } catch (error) {
    console.error(error);
  }
}

// Function to update dashboard HTML elements
function updateDashboard() {
  balanceElement.textContent = formatCurrency(balance);
  profitElement.textContent = formatCurrency(profit);
  updateChart();
}

// Function to update chart
function updateChart() {
  const ctx = chartContainer.getContext('2d');
  new Chart(ctx, {
    type: 'line',
    data: {
      labels: chartData.map((point) => point.date),
      datasets: [{
        label: 'Balance',
        data: chartData.map((point) => point.balance),
        backgroundColor: 'rgba(255, 99, 132, 0.2)',
        borderColor: 'rgba(255, 99, 132, 1)',
        borderWidth: 1
      }]
    },
    options: {
      scales: {
        y: {
          beginAtZero: true
        }
      }
    }
  });
}

// Function to handle refresh button click
document.getElementById('refresh-button').addEventListener('click', fetchDashboardData);

// Initialize dashboard
fetchDashboardData();