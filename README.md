# Projeto de Perguntas e Respostas

Este projeto foi desenvolvido com o objetivo de consolidar meus conhecimentos em Ruby on Rails, construindo uma plataforma completa de perguntas e respostas com autenticação, painéis interativos, e gestão de conteúdo.

## 🚀 Tecnologias Utilizadas
* Ruby on Rails
* Devise (ferramenta de autenticação)
* SQLite
* JavaScript
* HTML, CSS & Bootstrap 

## ⚙️ Funcionalidades
* Autenticação completa com Devise (login, logout, cadastro e recuperação de senha)
* CRUD completo para usuários, assuntos, questões e respostas
* Controle de permissões com dois perfis de usuário:
  * Usuário: responder perguntas e acompanhar desempenho em gráficos
  * Administrador: gerenciar todo o conteúdo e visualizar métricas gerais
* Dashboards interativos em JS:
  * Desempenho individual (respostas corretas, incorretas e total respondido)
  * Painel administrativo com estatísticas globais
    
## 🌐 APIs Utilizadas

#### API Externa do ViaCEP: 
* Utilizada para preenchimento automático dos dados de endereço a partir do CEP informado pelo usuário no cadastro.

#### API Interna - Perguntas por Assunto:
* Ao clicar em um assunto, busca todas as perguntas relacionadas no banco de dados;
* Exibe dinamicamente um card com as perguntas daquele assunto;
* Ao clicar em uma pergunta, busca todas as respostas possíveis e exibe outro card;
* Após o envio da resposta, a API valida se está correta ou incorreta, exibe o resultado na tela e atualiza as estatísticas do usuário.

#### API Interna - Atualização de Estatísticas:
* Atualiza em tempo real os cards de desempenho do usuário, refletindo acertos, erros e totais respondidos após cada resposta.

## Pré-visualização
![home_user](./app/assets/images/home_user.jpg)
![edit_user](./app/assets/images/edit_user.jpg)
![question_user](./app/assets/images/question_user.jpg)
![home_adm](./app/assets/images/home_adm.jpg)
![list_users](./app/assets/images/list_users.jpg)
![list_subjects](./app/assets/images/list_subjects.jpg)
![list_questions](./app/assets/images/list_questions.jpg)

