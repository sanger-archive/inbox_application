require 'rails_helper'

RSpec.describe InboxesHelper, type: :helper do
  it '#bootstrap_class_helper' do
    expect(bootstrap_inbox_class(:active)).to     eq('success')
    expect(bootstrap_inbox_class(:inactive)).to   eq('danger')
    expect(bootstrap_inbox_class(:deprecated)).to eq('danger')
    expect(bootstrap_inbox_class(:detached)).to   eq('warning')
    expect(bootstrap_inbox_class(:exitless)).to   eq('warning')
    expect(bootstrap_inbox_class(:unknown)).to    eq('warning')
  end
end
