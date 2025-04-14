//JS do answer, onde tem um api para buscar as questions, e a função de clicar e abrir o card com as peruntas

// Declaramos a função no objeto global 'window' para que possa ser acessada pelo HTML inline (ex: onclick="LoadCardQuestion(...)")
window.LoadCardQuestion = function(id) { 
   let cardQuestions = document.getElementById('cardQuestion');
   cardQuestions.style.display = "block";
   loadData(id);
};

async function loadData(subject_id) {
   try {
      const questions = await fetch(`/api/questions?subject_id=${subject_id}`) // ele chama a requisição
      if (!questions.ok) throw new Error('Erro na API');

      const data = await answer.json() // ele pega a requisição e transforma em json
      document.getElementById('questions').innerText = data
      //console.log(data); // aqui você atualiza a UI, por exemplo
   } catch (erro) {
      console.error('Erro ao buscar os dados:', erro);
   }
}
