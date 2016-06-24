# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Run these seeds in production

# These seeds are used in development to provide immediate material to
# work with. They should NOT be run in production
if Rails.env == 'development'
  ActiveRecord::Base.transaction do
    t = Team.new(name:'Example Team')
    i1 = Inbox.create!(name: 'Example Inbox A')
    i2 = Inbox.create!(name: 'Example Inbox B')
    t.team_inboxes.build([{inbox:i1,order:0},{inbox:i2,order:1}])
    t.save!
  end
end
