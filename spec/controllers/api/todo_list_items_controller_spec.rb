require 'rails_helper'
require_relative 'shared'

describe Api::TodoListItemsController do
  render_views

  let(:format) { :json }
  let(:todo_list) { TodoList.create(name: 'Shopping List') }
  let(:todo_item) { TodoListItem.create(text: 'Apples', todo_list:) }

  let(:params) { { id: todo_item.id, todo_list_id: todo_list.id } }

  shared_examples 'returning a todo_item record' do
    it 'returns a valid record' do
      json_response = JSON.parse(response.body)

      aggregate_failures 'includes all fields' do
        fields = %w[id text created_at updated_at todo_list_id]

        expect(json_response.keys).to include(*fields)
        expect(json_response['id']).to eq(expected_todo_item.id)
        expect(json_response['text']).to eq(expected_todo_item.text)
        expect(json_response['created_at'].to_time)
          .to be_within(1.second).of(expected_todo_item.created_at)
        expect(json_response['updated_at'].to_time)
          .to be_within(1.second).of(expected_todo_item.updated_at)
      end
    end
  end

  shared_examples 'invalid or non-existent todo_list/todo_item' do
    context 'when todo_list does not exist' do
      let(:params) { super().merge(todo_list_id: 99) }

      it_behaves_like 'a not found error'
    end

    context 'when todo_item does not exist' do
      let(:params) { super().merge(id: 99) }

      it_behaves_like 'a not found error'
    end

    context 'when todo_item does not belong to todo_list' do
      let(:todo_item_2) do
        todos = TodoList.create(name: 'First Aid kit')
        TodoListItem.create(text: 'Bandages', todo_list: todos)
      end

      let(:params) { super().merge(id: todo_item_2.id) }

      it_behaves_like 'a not found error'
    end
  end

  describe 'show' do
    subject(:make_request) { get(:show, params:, format:) }

    it_behaves_like 'rejecting not supported mime formats'

    context 'when format is JSON' do
      before { make_request }

      it_behaves_like 'invalid or non-existent todo_list/todo_item'

      context 'when todo_item belongs to todo_list' do
        let(:expected_todo_item) { todo_item }

        it_behaves_like 'a successfull request'
        it_behaves_like 'returning a todo_item record'
      end
    end
  end

  describe 'destroy' do
    subject(:make_request) { delete(:destroy, params:, format:) }

    it_behaves_like 'rejecting not supported mime formats'

    context 'when format is JSON' do
      before { make_request }

      it_behaves_like 'invalid or non-existent todo_list/todo_item'

      context 'when todo_item belongs to todo_list' do
        let(:expected_status_code) { :no_content }

        it_behaves_like 'a successfull request'

        it 'deletes the record' do
          expect { todo_item.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when record fails to be destroyed' do
      let(:expected_status_code) { :unprocessable_entity }
      let(:expected_errors) do
        "Failed to destroy TodoListItem with id=#{todo_item.id}"
      end

      before do
        allow_any_instance_of(TodoListItem)
          .to receive(:destroy!)
          .and_raise(
            ActiveRecord::RecordNotDestroyed,
            expected_errors
          )

        make_request
      end

      it_behaves_like 'an invalid request'
    end
  end
end
