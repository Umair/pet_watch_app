# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.destroy_all
Pet.destroy_all

user = User.create!(email: 'test@example.com', password: 'password')

Pet.create!(name: 'Buddy', breed: 'Golden Retriever', age: 3, vaccination_expired: false, user: user)
Pet.create!(name: 'Mittens', breed: 'Tabby', age: 2, vaccination_expired: false, user: user)
Pet.create!(name: 'Rex', breed: 'German Shepherd', age: 5, vaccination_expired: true, user: user)
