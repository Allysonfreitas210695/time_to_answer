namespace :dev do

  DEFAULT_PASSWORD = 123456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc 'configura o ambiente de desenvolvimento'
  task setup: :environment do
    if Rails.env.development?
      show_spinner('apagando BD...', 'banco apagando com sucesso!') { `rails db:drop` }
      show_spinner('Criando o BD...', 'BD criando com sucesso!') { `rails db:create` }
      show_spinner('migrando o BD...', 'migração com sucesso!') { `rails db:migrate` }
      show_spinner('Cadastrado Administrador Padrão...', 'criado com sucesso!') { %x(rails dev:add_default_admin) }
      show_spinner('cadastrado Users....') { %x(rails dev:add_extra_admins) }
      show_spinner('cadastrado Administrador extras....') { %x(rails dev:add_default_user) }
      show_spinner('cadastrado Assuntos Padrões....') { %x(rails dev:add_subjects) }
      show_spinner("Cadastrando perguntas e respostas...") { %x(rails dev:add_answers_and_questions) }
    else
      puts 'Você não está em desenvolvimento!!'
    end
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona administradores extras"
  task add_extra_admins: :environment do
    10.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc "Adiciona Questões e Respostas"
  task add_answers_and_questions: :environment do
    Subject.all.each do |subject|
      rand(5..10).times do |i|
        params = create_question_params(subject)
        answers_array = params[:question][:answers_attributes]

        add_answers(answers_array)
        elect_true_answer(answers_array)

        Question.create!(params[:question])
      end
    end
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona assuntos padrão"
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    puts file_path

    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end


  desc "Resta o contato dos assuntos"
  task reset_subject_counter: :environment do
    show_spinner('Atualizando o total de assuntos....') do
      Subject.find_each do |subject|
        Subject.reset_counters(subject.id, :questions)
      end
    end
  end

  desc "Adiciona todas as respostas no Redis"
  task add_answers_to_redis: :environment do
    show_spinner('Adiciona todas as respostas no Redis') do
      Answer.find_each do |answer|
        Rails.cache.write(answer.id, "#{answer.question_id}@@#{answer.correct}")
      end
    end
  end

  private

  def create_question_params(subject = Subject.all.sample)
    { question: {
      description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
      subject: subject,
      answers_attributes: []
    }}
  end


  def create_answer_params(correct = false)
    { description: Faker::Lorem.sentence, correct: correct }
  end

  def add_answers(answers_array = [])
    rand(1..4).times do |j|
      answers_array.push(
        create_answer_params
      )
    end
  end

  def elect_true_answer(answers_array = [])
    elect_index = rand(answers_array.size)
    answers_array[elect_index] = create_answer_params(true)
  end

  def show_spinner(msg_start, msg_end = 'Concluido!!')
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :pulse_2)
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
