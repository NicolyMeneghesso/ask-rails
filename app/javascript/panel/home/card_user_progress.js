//CARD DE QUANTIDADE DE PERGUNTAS RESPONDIDAS TELA USUARIO 
async function loadProgressChart() {
  const response = await fetch('/api/charts/user_graph_answers');
  const progressChart = await response.json();
  
  const canvasProgress = document.getElementById("progressChart").getContext("2d")

  // Chart e um objeto da biblioteca Chart.js
  new Chart(canvasProgress, {
    type: 'doughnut', //Tipo de gráfico 
    data: {
      labels: ['Total respondido', 'Total de questões'], // Rótulos das fatias do gráfico
      datasets: [{ // Conjunto de dados (pode ter mais de um)
        data: [ progressChart.questionUser, progressChart.questionSite ],
        backgroundColor: ['#e9ecef', '#495057'], // Cor de fundo de cada fatia
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
  loadProgressChart();
});
