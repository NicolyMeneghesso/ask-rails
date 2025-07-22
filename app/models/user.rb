class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_question_answers, dependent: :destroy
  has_many :user_statistics, dependent: :destroy
  # dependent: :destroy - garante que todas as respostas associadas a ele sejam excluidas

  # O attribute Enum mapeia valores inteiros para nomes simbólicos legíveis,
  # adiciona métodos auxiliares como user.comum?
  enum :user_type, { regular: 0, admin_user: 1, super_admin: 2 }

  # Método que retorna o nome completo do usuário
  def full_name
    "#{first_name} #{last_name}"
  end

  # 1. Define um "atributo virtual" chamado skip_password_notification
  attr_accessor :skip_password_notification

  # 2. Após atualizar o usuário, chama o método send_password_change_notification
  #    MAS apenas se a senha foi alterada E a flag skip_password_notification NÃO está ativada
  after_update :send_password_change_notification, if: -> {
    saved_change_to_encrypted_password? && !skip_password_notification
  }

  # 3. Esse método é responsável por enviar o e-mail
  def send_password_change_notification
    Devise::Mailer.password_change(self).deliver_later
  end

  # Validações - para nao enviar o nome vazio
  with_options presence: true, length: { minimum: 4, maximum: 20 }, on: :update do
    validates :first_name
    validates :last_name
  end
  with_options presence: true, on: :update do
    validates :address_street
    validates :address_building_number
    validates :address_city
    validates :address_state
    validates :address_country
  end

  paginates_per 6
end
