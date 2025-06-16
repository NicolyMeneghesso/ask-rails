async function loadChartDataUsers() {
  const response = await fetch('/api/charts/active_users');
  const activeUsers = await response.json();

  const canvasActiveUsers = document.getElementById("activeUsers").getContext("2d")

  const chartActiveUsers = new Chart(canvasActiveUsers, {
    type: 'doughnut', //Tipo de gráfico 
    data: {
      labels: ['Usuários ativos', 'Usuários inativos'], // Rótulos das fatias do gráfico
      datasets: [{ // Conjunto de dados (pode ter mais de um)
        data: [activeUsers.active, activeUsers.inactive], 
        backgroundColor: ['#4bc0c0', '#ff6384'], // Cor de fundo de cada fatia
        borderWidth: 1 // Espessura da borda da fatia
      }]
    },
    options: { // Opções de personalização
      responsive: false, // O gráfico se adapta ao tamanho da tela
      cutout: '75%', // Aqui você controla a espessura
      plugins: {
        legend: {
          display: false
        }
      }
    }
  })
}

document.addEventListener("DOMContentLoaded", () => {
  loadChartDataUsers();
  setInterval(loadChartDataUsers, 60000); // Atualiza a cada 60 segundos
});