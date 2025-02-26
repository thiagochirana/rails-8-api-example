class User < ApplicationRecord
  has_secure_password
  has_many :addresses, dependent: :destroy
  accepts_nested_attributes_for :addresses, allow_destroy: true

  enum :role, { admin: "admin", user: "user" }
  enum :document_type, { CPF: "CPF", CNPJ: "CNPJ" }
  
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :document_number, uniqueness: true, if: :document_number_is_present?
  normalizes :email, with: ->(e) { e.strip.downcase }
  validates :password, presence: true, length: { minimum: 8 }, on: :create
  validate :password_does_not_contain_spaces
  validate :password_does_not_contain_invalid_chars
  
  after_initialize :set_document_type
  after_initialize :set_role_user
  validate :document_number_is_valid?
  
  def self.authenticating(params)
    if params[:login].include?("@")
      authenticate_by(email: params[:login], password: params[:password])
    elsif CPF.valid?(params[:login]) || CNPJ.valid?(params[:login])
      authenticate_by(document_number: params[:login], password: params[:password])
    end
  end

  private

  def set_document_type
    return unless document_number.present?
    self.document_type = if CPF.valid?(document_number)
      :CPF
    elsif CNPJ.valid?(document_number)
      :CNPJ
    end
  end

  def set_role_user
    self.role = :user unless self.role
  end

  def document_number_is_valid?
    return unless document_number.present?
    is_valid = case document_type
    when 'CPF'
      CPF.valid?(document_number)
    when 'CNPJ'
      CNPJ.valid?(document_number)
    end
    
    errors.add(:document_number, "não é válido") unless is_valid
  end

  def document_number_is_present?
    self.document_number.present?
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
