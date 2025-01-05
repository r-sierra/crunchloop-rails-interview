require 'rails_helper'

describe TodoList do
  describe 'associations' do
    it { is_expected.to have_many(:todo_list_items).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
