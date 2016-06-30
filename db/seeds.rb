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

    u1 = User.create!(login:'example1')
    u2 = User.create!(login:'example2')

    t  = Team.new(name:'Example Team')
    i1 = Inbox.create!(name: 'Example Inbox A')
    i2 = Inbox.create!(name: 'Example Inbox B')
    t.team_inboxes.build([{inbox:i1,order:0},{inbox:i2,order:1}])
    t.save!

    t2 = Team.new(name:'Other Team')
    i3 = Inbox.create!(name: 'Other Inbox A')
    i4 = Inbox.create!(name: 'Other Inbox B')
    i5 = Inbox.create!(name: 'Other Inbox C')
    t2.team_inboxes.build([{inbox:i1,order:0},{inbox:i2,order:1},{inbox:i3,order:2}])
    t2.save!

    details = {
      :primary_details => {'Key A'=>'Value A'},
      :secondary_details=>{'Key B'=>'Value B'},
      :primary_associations => {'association'=>['one','two']},
      :secondary_associations => {'association_2'=>['three','four']}
    }

    [i1,i2,i3,i4,i5].each_with_index do |inbox,ibi|
      5.times {|i| Item.create!(uuid: SecureRandom.uuid, name:"Unclaimed Item #{ibi}-#{i}",details:details,inbox:inbox)}
      b1 = Batch.create!(user:u1)
      2.times {|i| Item.create!(uuid: SecureRandom.uuid, name:"Batched Item #{ibi}-#{i}",details:details,inbox:inbox,batch:b1)}
      b2 = Batch.create!(user:u1)
      3.times {|i| Item.create!(uuid: SecureRandom.uuid, name:"Batched 2 Item #{ibi}-#{i}",details:details,inbox:inbox,batch:b2)}
      Item.create!(uuid: SecureRandom.uuid, name:"Completed Item #{ibi}-1",details:details,inbox:inbox,batch:b2,completed_at:Time.now)
      Item.create!(uuid: SecureRandom.uuid, name:"Completed Item #{ibi}-2",details:details,inbox:inbox,completed_at:Time.now)
    end
  end
end
