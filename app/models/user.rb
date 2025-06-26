class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :user_question_answers

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
