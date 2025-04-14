//JS do form de questions, onde define a quantidade de respostas pode ter cada pergunta

document.addEventListener("DOMContentLoaded", function () {
    const container = document.getElementById("answers-container");
    const addAnswerBtn = document.getElementById("add-answer-btn");
    const answerTemplate = document.getElementById("answer-template").content;
    let answerCount = document.querySelectorAll(".nested-answer").length; // Contar respostas existentes
 
    addAnswerBtn.addEventListener("click", function () {
      if (answerCount < 4) {
         const newAnswer = answerTemplate.cloneNode(true);
         container.appendChild(newAnswer);
         answerCount++;
      } else {
         alert("Você só pode adicionar até 4 respostas.");
      }
    });
 
    container.addEventListener("click", function (event) {
      if (event.target.classList.contains("remove-answer")) {
         event.target.closest(".nested-answer").remove();
         answerCount--;
      }
    });
});