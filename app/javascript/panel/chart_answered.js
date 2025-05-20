document.addEventListener("DOMContentLoaded", function () {
    const canvas = document.getElementById("questionsChart")
    const graphics = canvas.getContext("2d")

    // Chart e um objeto da biblioteca Chart.js
    const chart = new Chart(graphics, {
        type: 'doughnut', //Define o tipo de gráfico 
    })
    
})
