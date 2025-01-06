require 'rails_helper'

describe TodoList do
  describe 'associations' do
    it { is_expected.to have_many(:items).class_name('TodoListItem').dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
