class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_question_answers

  # Escopo que retorna apenas usuários comuns ou admins - reutilizavel nos controllers
  scope :admins_only, -> { where(user_type: [ 1, 2 ]) }
  scope :users_only, -> { where(user_type: 0) }
  # Escopo que busca usuários pelo primeiro ou último nome
  scope :search_by_name, ->(term) {
    where("first_name LIKE :term OR last_name LIKE :term", term: "%#{term}%") if term.present?
  }

  # Método que retorna o nome completo do usuário
  def full_name
    "#{first_name} #{last_name}"
  end

  # para nao enviar o nome vazio
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
