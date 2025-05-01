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

//esta funcao carrega mesmo antes do evento de pintar o td
async function loadDataQuestion(subject_id) {
   try {
      const questions = await fetch(`/api/questions?subject_id=${subject_id}`) // ele chama a requisição
      if (!questions.ok) throw new Error('Erro na API')

      const dataQuestions = await questions.json() // ele pega a requisição e transforma em json

      let tableBodyQuestions = document.getElementById('tableQuestions')
      tableBodyQuestions.innerHTML = ''  // limpa conteúdo anterior

      dataQuestions.forEach(question => { //pega a array e percorre ela, e a variavel question representa uma pergunta
         const tr = document.createElement('tr')
         const td = document.createElement('td')

         td.textContent = question.description // textContent insere texto puro,
         td.style.cursor = 'pointer'
      
         // Chamada ao clicar na pergunta
         td.onclick = (event) => loadCardAnswer(event, question.id)

         tr.appendChild(td); //Adiciona a célula (<td>) criada à linha (<tr>) da tabela.
         tableBodyQuestions.appendChild(tr); //Adiciona a nova linha (<tr>) com a pergunta na tabela visível da página, momento em que o conteúdo realmente é inserido no HTML
      });
      
   } catch (erro) {
      console.error('Erro ao buscar os dados:', erro);
   }
}

window.loadCardAnswer = async function(event, question_id) {

   const tdQuestion = event.target
   const tableBodyQuestions = document.getElementById('tableQuestions')

   // Limpa todos os td
   tableBodyQuestions.querySelectorAll('td').forEach(tdre => {
      tdre.classList.remove("td-selected");
   });

   tdQuestion.classList.add("td-selected");

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
         li.className = 'list-group-item d-flex align-items-center'

         // Cria o checkbox
         const checkbox = document.createElement('input')
         checkbox.type = 'radio'
         checkbox.name = 'answer'
         checkbox.className = 'form-check-input me-2'
         checkbox.value = answer.id
         
         // Cria o texto da resposta
         const span = document.createElement('span')
         span.innerText = answer.description //Usa innerText ou innerHTML com <br> se tiver \n

         // Junta no item da lista
         li.appendChild(checkbox) //Add o checkbox dentro do <li>.
         li.appendChild(span) //add o texto da resposta depois do checkbox
         list.appendChild(li)
        
      });
    
      cardAnswer.style.display = 'block'; // Mostra o card de respostas
    
   } catch (error) {
      console.error('Erro ao buscar as respostas:', error);
   }
}

window.SubmitAnswer = async function() {
   const list = document.getElementById('listAnswers')
   let answerId = 0;

   list.querySelectorAll('input').forEach(inp => {
      if (inp.checked) //verifica se esta marcado
         answerId = inp.value; //se estiver marcado, guarda o valor
   });

   if (answerId == 0) { 
      return;
   }

   const answer = await fetch(`/api/questions/answer_check?answer_id=${answerId}`) // ele chama a requisição
   if (!answer.ok) throw new Error('Erro na API')

   const dataAnswer = await answer.json()

   if (dataAnswer.correct) {
      console.log(" certo ")
   }else 
      console.log(" errado ")
}