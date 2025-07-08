document.addEventListener("DOMContentLoaded", function () {
  // Cria uma nova instância do TomSelect no select com id "user-select"
  new TomSelect("#user-select", {

    // Define qual campo do JSON será usado como valor no <option>
    valueField: "id",

    // Define qual campo do JSON será mostrado como texto visível
    labelField: "text",

    // Define qual campo será usado na pesquisa (quando o usuário digitar)
    searchField: "text",

    // Não permite criar novas opções digitando (apenas selecionar as já existentes)
    create: false,

    placeholder: "Buscar usuário...",

    // Função que carrega os dados do servidor com base no que o usuário digitou
    load: function (query, callback) {
      // Se nada foi digitado, não faz nenhuma requisição
      if (!query.length) return callback();

      // Envia uma requisição para a rota Rails com o termo pesquisado
      fetch(`/panel/admin/users/search.json?term=${encodeURIComponent(query)}`)
        // Converte a resposta para JSON
        .then(response => response.json())

        // Passa os dados para o TomSelect exibir como opções
        .then(callback)

        // Se der erro, apenas chama o callback com uma lista vazia
        .catch(() => callback());
    }
  });
});