class User < ApplicationRecord
  has_secure_password

  enum :role, admin: "admin", user: "user", default: :user

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  normalizes :email, with: ->(e) { e.strip.downcase }
  validates :password, presence: true, length: { minimum: 8 }, on: :create
  validate :password_does_not_contain_spaces
  validate :password_does_not_contain_invalid_chars

  def self.authenticating(params)
    if params[:login].include?("@")
      authenticate_by(email: params[:login], password: params[:password])
    elsif CPF.valid?(params[:login]) || CNPJ.valid?(params[:login])
      authenticate_by(document_number: params[:login], password: params[:password])
    end
  end

  def password_present?
    password.present?
  end

  def password_does_not_contain_spaces
    if password =~ /\s/
      errors.add(:base, "Senha não pode conter espaços")
    end
  end

  def password_does_not_contain_invalid_chars
    if password =~ /[áàãâäéèêëíìîïóòôõöúùûüçÇ]/
      errors.add(:base, "Senha não pode conter acentos ou caracteres especiais como Ç")
      true
    end
  end
end
