document.addEventListener("DOMContentLoaded", function() {
   // Função chamada ao clicar em um assunto. Mostra o card de perguntas e carrega as perguntas do assunto selecionado
   window.OnClickSubject = function(event) { //define uma função anônima que recebe o evento de clique como parâmetro.
      const td = event.target 
      const cardQuestions = document.getElementById('cardQuestion');
      cardQuestions.style.display = "block";
      loadDataQuestion(td.dataset.id); // Chama a API para buscar as perguntas do assunto

      // Remove a seleção anterior e aplica estilo no item clicado
      document.querySelectorAll('td').forEach(tdr => {
         tdr.classList.remove("td-selected");
      });

      td.classList.add("td-selected");
   }
   
});

// esta funcao: Busca as perguntas relacionadas ao assunto e preenche a tabela dinamicamente
async function loadDataQuestion(subject_id) {
   try {
      const questions = await fetch(`/api/questions?subject_id=${subject_id}`) // ele chama a requisição
      if (!questions.ok) throw new Error('Erro na API')

      const dataQuestions = await questions.json() // ele pega a requisição e transforma em json

      let tableBodyQuestions = document.getElementById('tableQuestions')
      tableBodyQuestions.innerHTML = ''  // limpa conteúdo anterior

      dataQuestions.forEach(question => { // Array percorre cada dataQuestion, e a variavel question representa uma pergunta
         const tr = document.createElement('tr') // Cria as linhas da tabela para cada pergunta
         const td = document.createElement('td')

         td.textContent = question.description // textContent insere texto puro,
         td.style.cursor = 'pointer'
      
         // Chamada as respostas ao clicar na pergunta
         td.onclick = (event) => loadCardAnswer(event, question.id)

         tr.appendChild(td); //Adiciona a célula (<td>) criada à linha (<tr>) da tabela.
         tableBodyQuestions.appendChild(tr); //Adiciona a nova linha (<tr>) com a pergunta na tabela visível da página, momento em que o conteúdo realmente é inserido no HTML
      });
      
   } catch (erro) {
      console.error('Erro ao buscar os dados:', erro);
   }
}

// Carrega e exibe as respostas da pergunta selecionada
window.loadCardAnswer = async function(event, question_id) {

   // Remove seleção anterior e destaca pergunta clicada
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
      const list = document.getElementById('listAnswers') // ul da resposta
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
         span.innerText = answer.description //Usa innerText

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

// Função global: esconde os alerts
function hideAlerts() {
   ["answerCorrect", "answerWrong"].forEach(id => {
     const el = document.getElementById(id);
     if (!el) return;
 
     el.classList.remove("show", "fade");
     el.classList.add("d-none");
     el.setAttribute("style", "");
   });
}

// Envia a resposta selecionada e exibe se está certa ou errada
window.SubmitAnswer = async function() {
   hideAlerts(); 
   const list = document.getElementById('listAnswers')
   let answerId = 0;

   // Encontra a resposta marcada
   list.querySelectorAll('input').forEach(inp => {
      if (inp.checked) //verifica se esta marcado
         answerId = inp.value; //se estiver marcado, guarda o valor
   });

   if (answerId == 0) { // Se nenhuma resposta foi marcada, não faz nada
      return;
   }

   const answer = await fetch(`/api/questions/answer_check?answer_id=${answerId}`) // ele chama a requisição
   if (!answer.ok) throw new Error('Erro na API')

   const dataAnswer = await answer.json()
   
   const answerCorrect = document.getElementById('answerCorrect');
   const answerWrong = document.getElementById('answerWrong');

   if (dataAnswer.correct) {
      answerCorrect.classList.remove("d-none");
      answerCorrect.classList.add("fade","show");
   } else {
      answerWrong.classList.remove("d-none");
      answerWrong.classList.add("fade","show");
   }
}