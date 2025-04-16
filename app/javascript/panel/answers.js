//JS do answer, onde tem um api para buscar as questions, e a função de clicar e abrir o card com as peruntas

// Declaramos a função no objeto global 'window' para que possa ser acessada pelo HTML inline (ex: onclick="LoadCardQuestion(...)")
window.loadCardQuestion = function(id) { 
   let cardQuestions = document.getElementById('cardQuestion')
   cardQuestions.style.display = "block"
   loadDataQuestion(id)
};

async function loadDataQuestion(subject_id) {
   try {
      const questions = await fetch(`/api/questions?subject_id=${subject_id}`) // ele chama a requisição
      if (!questions.ok) throw new Error('Erro na API')

      const dataQuestion = await questions.json() // ele pega a requisição e transforma em json

      let tableBody = document.getElementById('tableQuestions')
      tableBody.innerHTML = ''  // limpa conteúdo anterior

      dataQuestion.forEach(question => { //pega a array e percorre ela, e a variavel question representa uma pergunta
         const tr = document.createElement('tr')
         const td = document.createElement('td')

         td.textContent = question.description // textContent insere texto puro,
         td.style.cursor = 'pointer'

         // Chamada ao clicar na pergunta
         td.onclick = () => loadCardAnswer(question.id)

         tr.appendChild(td); //Adiciona a célula (<td>) criada à linha (<tr>) da tabela.
         tableBody.appendChild(tr); //Adiciona a nova linha (<tr>) com a pergunta na tabela visível da página, momento em que o conteúdo realmente é inserido no HTML
      });
      
   } catch (erro) {
      console.error('Erro ao buscar os dados:', erro);
   }
}

window.loadCardAnswer = async function(question_id) {
   try {
      const answers = await fetch(`/api/questions/answers?question_id=${question_id}`) // ele chama a requisição
      if (!questions.ok) throw new Error('Erro na API')

      const dataAnswer = await answers.json()

      let cardAnswer = document.getElementById('cardAnswer')
      let listAnswer = document.getElementById('listAnswers')
      listAnswer.innerHTML = ''

      dataQuestion.forEach(answer => { 
         const li = document.createElement('li')
         li.className = 'list-group-item d-flex justify-content-between align-items-center';
         li.textContent = answer.description

         if (answer.correct) {
            const badge = document.createElement('span');
            badge.className = 'badge bg-success';
            badge.textContent = '✔';
            li.appendChild(badge);
         }
    
         list.appendChild(li);
      });
    
      card.style.display = 'block';
    
   } catch (error) {
      console.error('Erro ao buscar as respostas:', error);
   }
}