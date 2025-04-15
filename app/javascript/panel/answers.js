//JS do answer, onde tem um api para buscar as questions, e a função de clicar e abrir o card com as peruntas

// Declaramos a função no objeto global 'window' para que possa ser acessada pelo HTML inline (ex: onclick="LoadCardQuestion(...)")
window.loadCardQuestion = function(id) { 
   let cardQuestions = document.getElementById('cardQuestion');
   cardQuestions.style.display = "block";
   loadDataQuestion(id);
};

async function loadDataQuestion(subject_id) {
   try {
      const questions = await fetch(`/api/questions?subject_id=${subject_id}`) // ele chama a requisição
      if (!questions.ok) throw new Error('Erro na API');

      const dataQuestion = await questions.json() // ele pega a requisição e transforma em json

      let tableBody = document.getElementById('tableQuestions');
      tableBody.innerHTML = ''  // limpa conteúdo anterior

      dataQuestion.forEach(question => { //pega a array e percorre ela, e a variavel question representa uma pergunta
         const tr = document.createElement('tr');
         const td = document.createElement('td');
         td.textContent = question.description;
         tr.appendChild(td);
         tableBody.appendChild(tr);
      });
      
   } catch (erro) {
      console.error('Erro ao buscar os dados:', erro);
   }
}

window.loadCardAnswer = function(id_answer) { 
   let cardAnswer = document.getElementById('cardQuestion');
   cardAnswer.style.display = "block";
   loadDataAnswer(id_answer);
};