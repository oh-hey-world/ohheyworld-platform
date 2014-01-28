# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.where(email: 'eric.roland@gmail.com').first
user.make_admin if user
user = User.where(email: 'eric@ericroland.com').first
user.make_admin if user

