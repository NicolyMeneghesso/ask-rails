namespace :dev do

  DEFAULT_PASSWORD = 123456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do 
    if Rails.env.development?
      show_spinner("Apagando BD...") {%x(rails db:drop)}
      show_spinner("Criando BD...") {%x(rails db:create)}
      show_spinner("Migrando BD...") {%x(rails db:migrate)}
      show_spinner("Cadastrando o administrador padrão...") {%x(rails dev:add_default_admin)}
      show_spinner("Adicionando administradores extras...") {%x(rails dev:add_extra_admins)}
      show_spinner("Cadastrando o usuário padrão...") {%x(rails dev:add_default_user)}
      show_spinner("Cadastrando os assuntos padrões...") {%x(rails dev:add_subjects)}
      show_spinner("Cadastrando os perguntas e respostas...") {%x(rails dev:add_questions)}
    else 
      puts "Você não está em ambiente de desenvolvimento"
    end
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do 
    Admin.create!(
      email: "admin@admin.com",
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona outros administradores extras"
  task add_extra_admins: :environment do 
    4.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc "Adiciona username para os usuarios e administradores que não tem um definido"
  task add_username_extra: :environment do 
    Admin.all.each do |admin|
      admin.update(username: Faker::Name.name)
    end
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do 
    User.create!(
      email: "user@user.com",
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona os assuntos padrões"
  task add_subjects: :environment do 
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    Subject.delete_all
    ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='subjects'")
    
    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc "Adiciona questões e respostas padrões"
  task add_questions: :environment do 
    file_name = 'questions.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    Answer.delete_all
    ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='answers'")
    
    Question.delete_all
    ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='questions'")
   
    File.open(file_path, 'r').each do |line| #'r' indica que irá apenas ser aberto para leitura
      question_data = line.split(",")
      # Criando a questão
      created_question = Question.create!(subject_id: question_data[0], description: question_data[1])
       
      # Criando as respostas e marcando a opção C como correta
      (2..5).each_with_index do |index, i| #Gera os índices, onde index: nº real do indice, i: do loop
        Answer.create!(
          question_id: created_question.id,
          description: question_data[index].strip, # Removendo espaços extras
          correct: (i == 2) # Define a terceira opção (C) como verdadeira
        )
      end
    end
  end

  private
    def show_spinner(msg_start, msg_end = "Concluído!")
      spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
      spinner.auto_spin
      yield
      spinner.success("#{msg_end}")
    end

end
