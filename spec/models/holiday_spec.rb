require 'rails_helper'

RSpec.describe Holiday, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :date }
  end

  describe "relationships" do
    it { have_many :bulk_discounts }
  end

  before(:each) do 
    
  end

  describe 'class methods' do 
    describe '#upcoming_holidays(count)' do 
      it 'returns the next upcoming holidays with count based upon arg passed' do
        api = HolidayApi.new.get_holidays
        upcoming_holidays = Holiday.upcoming_holidays(3)
        holiday1 = upcoming_holidays[0]
        holiday2 = upcoming_holidays[1]
        holiday3 = upcoming_holidays[2]
        expect(upcoming_holidays.count).to eq(3)
        expect(upcoming_holidays).to eq([holiday1, holiday2, holiday3])
        expect(holiday1).to_not eq(holiday2)
        expect(holiday1).to_not eq(holiday3)
        expect(holiday2).to_not eq(holiday3)
      end 
    end
  end

 
end 