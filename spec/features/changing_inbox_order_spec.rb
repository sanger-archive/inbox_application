# spec/features/visitor_signs_up_spec.rb
require 'spec_helper'

RSpec.feature 'Adjusting inbox order', js: true do

  before(:each) do
    @existing = create :team_with_inbox
    @new_inbox = create :inbox
  end


  scenario 'adding a new inbox' do

    visit edit_team_path(@existing)

    expect(page).to have_content(@existing.name)

    edit_inbox_list = page.find('ol#edit-inbox-list')
    other_inbox_list = page.find('ul#other-inbox-list')

    edit_inbox_list.find('li',text:"#{@existing.inboxes.first.key}").drag_to(other_inbox_list)

    # expect(other_inbox_list).to have_css("#inbox-#{@existing.inboxes.first.key}",text:@existing.inboxes.first.key)

    other_inbox_list.find("li#inbox-#{@new_inbox.key}").drag_to(edit_inbox_list)

    page.find_button('Update Inboxes').click
    expect(page).to have_content('Great! Team was successfully updated')
    @existing.reload
    expect(@existing.inboxes.count).to eq(1)
    expect(@existing.inboxes).to include(@new_inbox)
  end
end
