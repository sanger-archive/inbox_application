require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TeamsHelper. For example:
#
# describe TeamsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TeamsHelper, type: :helper do
  # pending "add some examples to (or delete) #{__FILE__}"
  describe 'active_tab?' do
    it "returns the second argument if the tab is active" do
      inbox = build :inbox
      @active_inbox = inbox
      expect(if_active_tab(inbox,'active')).to eq('active')
    end

    it "returns the nil if the tab is not-active" do
      inbox = build :inbox
      inbox2 = build :inbox
      @active_inbox = inbox
      expect(if_active_tab(inbox2,'active')).to be_nil
    end
  end
end
