require 'rails_helper'

describe TodoList do
  describe 'validations' do
    describe 'validates presence of #name' do
      let(:record) { described_class.new(name:) }

      context 'when #name is blank' do
        let(:name) { '' }

        it 'fails validation' do
          expect(record).not_to be_valid
        end

        it 'sets an error message' do
          record.validate

          expect(record.errors.added?(:name, :blank)).to be(true)
        end
      end

      context 'when #name is not blank' do
        let(:name) { 'Shopping List' }

        it 'succeeds validation' do
          expect(record).to be_valid
        end

        it 'does not set an error' do
          expect(record.errors).to be_empty
          # If #name had more validations then we should check that the
          # specific error is not set for the attribute
          #
          # expect(record.errors.added?(:name, :blank)).to be(false)
        end
      end
    end
  end
end
