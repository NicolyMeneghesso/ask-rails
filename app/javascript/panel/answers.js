//JS do answer, onde tem um api para buscar as questions, e a função de clicar e abrir o card com as peruntas

document.addEventListener("DOMContentLoaded", function() {
   window.OnClickSubject = function(event) {
      const td = event.target
      const cardQuestions = document.getElementById('cardQuestion');
      cardQuestions.style.display = "block";
      loadDataQuestion(td.dataset.id);

      // Limpa todos os td
      document.querySelectorAll('td').forEach(tdr => {
         tdr.classList.remove("td-selected");
      });

      td.classList.add("td-selected");
   }
   
});

async function loadDataQuestion(subject_id) {
   try {
      const questions = await fetch(`/api/questions?subject_id=${subject_id}`) // ele chama a requisição
      if (!questions.ok) throw new Error('Erro na API')

      const dataQuestion = await questions.json() // ele pega a requisição e transforma em json

      let tableBodyQuestions = document.getElementById('tableQuestions')
      tableBodyQuestions.innerHTML = ''  // limpa conteúdo anterior

      dataQuestion.forEach(question => { //pega a array e percorre ela, e a variavel question representa uma pergunta
         const tr = document.createElement('tr')
         const td = document.createElement('td')

         td.textContent = question.description // textContent insere texto puro,
         td.style.cursor = 'pointer'
      
         // Chamada ao clicar na pergunta
         td.onclick = () => loadCardAnswer(question.id)

         tr.appendChild(td); //Adiciona a célula (<td>) criada à linha (<tr>) da tabela.
         tableBodyQuestions.appendChild(tr); //Adiciona a nova linha (<tr>) com a pergunta na tabela visível da página, momento em que o conteúdo realmente é inserido no HTML
      });
      
   } catch (erro) {
      console.error('Erro ao buscar os dados:', erro);
   }
}

window.loadCardAnswer = async function(question_id) {
   try {
      const answers = await fetch(`/api/questions/answers?question_id=${question_id}`) // ele chama a requisição
      if (!answers.ok) throw new Error('Erro na API')

      const dataAnswer = await answers.json()

      // Aqui você acessa os elementos do DOM
      const cardAnswer = document.getElementById('cardAnswer')  // Div da resposta
      const list = document.getElementById('listAnswers')
      list.innerHTML = '' // limpa respostas anteriores

      // Aqui preenche com as novas respostas
      dataAnswer.forEach(answer => { 
         const li = document.createElement('li')
         li.className = 'list-group-item'

         // Usa innerText ou innerHTML com <br> se tiver \n
         li.innerText = answer.description
         list.appendChild(li)
      });
    
      cardAnswer.style.display = 'block'; // Mostra o card de respostas
    
   } catch (error) {
      console.error('Erro ao buscar as respostas:', error);
   }
}
