# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Message.destroy_all
Chat.destroy_all
Topic.destroy_all
User.destroy_all

user1 = User.create!(email: "middwin99@gmail.com", password: "123456")
user2 = User.create!(email: "paul.mikhailau@gmail.com", password: "234567")
user3 = User.create!(email: "florimelle@gmail.com", password: "345678")

math = Topic.create!(name: "Math", description: "Basic arithmetic and algebra questions")
geo = Topic.create!(name: "Geography", description: "World geography and capitals")
history = Topic.create!(name: "History", description: "World history and events")

chat1 = Chat.create!(user: user1, topic: math)

Message.create!(chat: chat1, sender: "bot", message_text: "What is 2 + 2?")
Message.create!(chat: chat1, sender: "user", message_text: "4")
Message.create!(chat: chat1, sender: "bot", message_text: "Correct! Well done!")

puts "Seeded #{User.count} users, #{Topic.count} topics, #{Chat.count} chats, and #{Message.count} messages!"
