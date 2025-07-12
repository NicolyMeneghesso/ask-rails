//CARD DE DESEMPENHO DE RESPOSTAS CERTAS E ERRADAS TELA DO USUARIO 
async function loadUserGraphAnswers() {
  const response = await fetch('/api/charts/user_graph_answers');
  const questionsChart = await response.json();

  const canvasQuestions = document.getElementById("questionsChart").getContext("2d")
  // Chart e um objeto da biblioteca Chart.js
  new Chart(canvasQuestions, {
    type: 'doughnut', //Tipo de gráfico 
    data: {
      labels: ['Certas', 'Erradas'], // Rótulos das fatias do gráfico

      datasets: [{ // Conjunto de dados (pode ter mais de um)
          data: [ questionsChart.right, questionsChart.wrong ],
          backgroundColor: ['#198754', '#dc3545'], // Cor de fundo de cada fatia
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
  loadUserGraphAnswers();
  setInterval(loadUserGraphAnswers, 60000); // Atualiza a cada 60 segundos
});
