require 'rails_helper'

describe TodoListItem do
  describe 'associations' do
    it { is_expected.to belong_to(:todo_list) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_length_of(:text).is_at_most(255) }
  end
end
