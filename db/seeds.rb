# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.where(email: 'admin@example.com').first_or_create!(name: 'Admin', password: 'password')
project = Project.where(git_url: 'git@github.com:afcapel/websocket_parser.git').first_or_create!(name: 'websocket_parser')
project.setup

project.tasks.create(name: "Install dependencies", command: "bundle install")
project.tasks.create(name: "Run specs", command: "bundle exec rspec spec")
