namespace :dev do
  DEFAULT_PASSWORD = 123456
  DEFAULT_FILES_PATH = File.join(Rails.root, "lib", "tmp")

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") { %x(rails db:drop) }
      show_spinner("Criando BD...") { %x(rails db:create) }
      show_spinner("Migrando BD...") { %x(rails db:migrate) }
      show_spinner("Cadastrando o usuário padrão...") { %x(rails dev:add_default_user) }
      show_spinner("Cadastrando os assuntos padrões...") { %x(rails dev:add_subjects) }
      show_spinner("Cadastrando os perguntas e respostas...") { %x(rails dev:add_questions) }
    else
      puts "Você não está em ambiente de desenvolvimento"
    end
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.delete_all
    ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'users'")

    # Criar um usuário admin geral
    User.create!(
      email: "superadmin@superadmin.com",
      user_type: 2,
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      address_street: Faker::Address.street_name,
      address_building_number: Faker::Address.building_number,
      address_city: Faker::Address.city,
      address_state: Faker::Address.state,
      address_country: Faker::Address.country_code_long
    )

     # Criar 4 usuários admins
     4.times do |i|
      User.create!(
        email: Faker::Internet.email(domain: "admin.com"),
        user_type: 1,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        address_street: Faker::Address.street_name,
        address_building_number: Faker::Address.building_number,
        address_city: Faker::Address.city,
        address_state: Faker::Address.state,
        address_country: Faker::Address.country_code_long
      )
    end

    # Criar usuários fictícios
    10.times do |i|
      User.create!(
        email: Faker::Internet.email(domain: "user.com"),
        user_type: 0,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        address_street: Faker::Address.street_name,
        address_building_number: Faker::Address.building_number,
        address_city: Faker::Address.city,
        address_state: Faker::Address.state,
        address_country: Faker::Address.country_code_long
      )
    end
  end

  desc "Adiciona os assuntos padrões"
  task add_subjects: :environment do
    file_name = "subjects.txt"
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    Subject.delete_all
    ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='subjects'")

    File.open(file_path, "r").each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc "Reseta o contador dos assuntos"
  task reset_subject_counter: :environment do
    show_spinner("Reseta o contador dos assuntos...") do
      Subject.find_each do |subject|
        Subject.reset_counters(subject.id, :questions)
      end
    end
  end

  desc "Adiciona questões e respostas padrões"
  task add_questions: :environment do
    file_name = "questions.txt"
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    Answer.delete_all
    ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='answers'")

    Question.delete_all
    ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='questions'")

    File.open(file_path, "r").each do |line| # 'r' indica que irá apenas ser aberto para leitura
      question_data = line.split("|")
      # Criando a questão
      created_question = Question.create!(subject_id: question_data[0], description: question_data[1])

      # Criando as respostas e marcando a opção C como correta
      (2..5).each_with_index do |index, i| # Gera os índices, onde index: nº real do indice, i: do loop
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
