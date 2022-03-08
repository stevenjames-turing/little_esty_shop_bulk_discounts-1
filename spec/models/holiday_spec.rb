require 'rails_helper'

RSpec.describe Holiday, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :date }
  end

  describe "relationships" do
    it { have_many :bulk_discounts }
  end

  
end 