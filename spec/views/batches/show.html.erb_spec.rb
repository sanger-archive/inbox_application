require 'rails_helper'

RSpec.describe "batches/show.html.erb", type: :view do
  it "should render the batch" do
    @batch = create :batch
    render
  end
end
