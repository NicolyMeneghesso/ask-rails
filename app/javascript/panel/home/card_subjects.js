//CARD DOS ASSUNTOS MAIS RESPONDIDOS TELA DO ADMIN 
let chartMostAnswered = null;

async function loadChartDataSubjects() {
  const response = await fetch('/api/charts/top_subjects');
  const topSubjects = await response.json();

  const labels = topSubjects.map(s => s.name); //Cria um array apenas com os nomes dos assuntos, no eixo y
  const data = topSubjects.map(s => s.count); // Cria um array com as quantidades de respostas por assunto

  const canvasMostAnswered = document.getElementById("MostAnsweredTopics").getContext("2d")  
   if (!canvasMostAnswered) {
    console.warn("Canvas 'MostAnsweredTopics' não encontrado.");
    return;
  }

  // Destroi o gráfico anterior, se existir
  if (chartMostAnswered) {
    chartMostAnswered.destroy();
  }
  // Chart e um objeto da biblioteca Chart.js
  new Chart(canvasMostAnswered, {
    type: 'bar', //Tipo de gráfico 
    data: {
      labels: labels,
      datasets: [{ 
        axis: 'x',
        label: '',
        data: data,
        backgroundColor: [
          'rgba(255, 99, 132, 0.2)',
          'rgba(54, 162, 235, 0.2)',
          'rgba(255, 206, 86, 0.2)',
          'rgba(75, 192, 192, 0.2)',
          'rgba(153, 102, 255, 0.2)', 
          'rgba(255, 159, 64, 0.2)',   
          'rgba(201, 203, 207, 0.2)'  

        ],
        borderColor: [
          'rgb(255, 99, 132)',
          'rgb(54, 162, 235)',
          'rgb(255, 206, 86)',
          'rgb(75, 192, 192)',
          'rgb(153, 102, 255)',
          'rgb(255, 159, 64)',
          'rgb(201, 203, 207)'
          ],
        borderWidth: 1
      }]
    },
    options: {
      indexAxis: 'y',
      plugins: {
        legend: {
          display: false
        }
      }
    }
  })
}

document.addEventListener("DOMContentLoaded", () => {
  loadChartDataSubjects();
});