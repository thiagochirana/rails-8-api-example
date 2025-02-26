class Address < ApplicationRecord
  belongs_to :user

  validates :name, :street, :number, :state, :country, :zip_code, presence: true
  validates :zip_code, format: { with: /\A\d{5}-\d{3}\z/, message: "deve estar no formato 12345-678" }
  
  normalizes :zip_code, with: ->(zip) { zip.gsub(/\D/, '') }
  normalizes :street, with: ->(s) { s.strip.titleize } 
  normalizes :state, with: ->(s) { s.strip.upcase }
end
