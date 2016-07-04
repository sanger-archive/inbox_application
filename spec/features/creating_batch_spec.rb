# spec/features/visitor_signs_up_spec.rb
require 'spec_helper'

RSpec.feature 'creating a batch', js: true do

  before(:each) do
    @existing = create :team_with_inbox
    @user = create :user
    @inbox = @existing.inboxes.first
    @items_to_select = 2.times.map { create :pending_item, inbox: @inbox }
    @items_to_ignore = 2.times.map { create :pending_item, inbox: @inbox }
    @all_items = @items_to_select + @items_to_ignore
    @original = User.external_service
    mul = MockUserLookup.new({uuid:@user.uuid,login:@user.login},'test')
    User.external_service = mul
  end

  after(:each) do
    User.external_service = @original
  end

  scenario 'adding a new inbox' do

    visit team_inbox_path(@existing,@inbox)

    expect(page).to have_content(@inbox.name)
    expect(page).to have_content('Pending')

    @all_items.map do |item|
      expect(page).to have_content(item.name)
    end

    @items_to_select.each do |item|
      page.check "Select #{item.name}"
    end

    page.fill_in 'User swipecard', with: 'test'
    page.click_on 'Create Batch'

    expect(page).to have_content('Great! Batch was created')
    expect(page).to have_content(@user.login)

    # Should seee the items we added
    @items_to_select.each do |item|
      expect(page).to have_content(item.name)
    end
    # And not the ones we didn't
    @items_to_ignore.each do |item|
      expect(page).to_not have_content(item.name)
    end

    visit team_inbox_path(@existing,@inbox)
    # Should seee the items we added
    @items_to_select.each do |item|
      expect(page).to_not have_content(item.name)
    end
    # And not the ones we didn't
    @items_to_ignore.each do |item|
      expect(page).to have_content(item.name)
    end
  end
end
