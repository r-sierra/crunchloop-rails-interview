require 'rails_helper'
require_relative 'shared'

describe Api::TodoListsController do
  render_views

  let(:format) { :json }
  let!(:todo_list) do
    TodoList.create(
      name: 'Setup RoR project',
      items: [
        TodoListItem.new(text: 'Item 1')
      ]
    )
  end

  shared_examples 'returning a todo list record' do
    it 'returns a valid record' do
      json_response = JSON.parse(response.body)

      aggregate_failures 'includes the id and name' do
        expect(json_response.keys).to include('name', 'id', 'items')
        expect(json_response['name']).to eq(expected_todo_list.name)
        expect(json_response['id']).to eq(expected_todo_list.id)
        if expected_todo_list.items.empty?
          expect(json_response['items']).to eq([])
        else
          expect(json_response['items']).to include(
            a_hash_including('id', 'text', 'created_at', 'updated_at')
          )
        end
      end
    end
  end

  shared_examples 'a request with invalid parameters' do
    context 'when :todolist is empty' do
      let(:params) { super().merge(todolist: {}) }
      let(:expected_status_code) { :bad_request }
      let(:expected_errors) { 'param is missing or the value is empty: todolist' }

      it_behaves_like 'an invalid request'
    end

    context 'when :name is empty' do
      let(:params) { super().merge(todolist: { name: '' }) }
      let(:expected_status_code) { :bad_request }
      let(:expected_errors) { ['Name can\'t be blank'] }

      it_behaves_like 'an invalid request'
    end
  end

  describe 'GET index' do
    subject(:make_request) { get(:index, format:) }

    it_behaves_like 'rejecting not supported mime formats'

    context 'when format is JSON' do
      before { make_request }

      it_behaves_like 'a successfull request'

      it 'includes todo list records' do
        todo_lists = JSON.parse(response.body)

        aggregate_failures 'includes the id and name' do
          expect(todo_lists.count).to eq(1)
          expect(todo_lists[0].keys).to match_array(%w[id name])
          expect(todo_lists[0]['id']).to eq(todo_list.id)
          expect(todo_lists[0]['name']).to eq(todo_list.name)
        end
      end
    end
  end

  describe 'show' do
    subject(:make_request) { get(:show, params:, format:) }

    let(:params) { { id: todo_list.id } }

    it_behaves_like 'rejecting not supported mime formats'

    context 'when format is JSON' do
      before { make_request }

      context 'when resource does not exist' do
        let(:params) { super().merge(id: 99) }

        it_behaves_like 'a not found error'
      end

      context 'when resource exists' do
        let(:expected_todo_list) { todo_list }

        it_behaves_like 'a successfull request'
        it_behaves_like 'returning a todo list record'
      end
    end
  end

  describe 'create' do
    subject(:make_request) { post(:create, params:, format:) }

    let(:params) { { todolist: { name: 'Shopping List' } } }

    it_behaves_like 'rejecting not supported mime formats'

    context 'when format is JSON' do
      before { make_request }

      context 'with valid parameters' do
        let(:expected_todo_list) { TodoList.find_by!(name: 'Shopping List') }

        it_behaves_like 'a successfull request'
        it_behaves_like 'returning a todo list record'
      end

      it_behaves_like 'a request with invalid parameters'
    end
  end

  describe 'update' do
    subject(:make_request) { put(:update, params:, format:) }

    let(:params) do
      {
        id: todo_list.id,
        todolist: {
          name: 'New shopping list'
        }
      }
    end

    it_behaves_like 'rejecting not supported mime formats'

    context 'when format is JSON' do
      before { make_request }

      context 'when resource exists' do
        context 'with valid parameters' do
          let(:expected_todo_list) { todo_list.reload }

          it_behaves_like 'a successfull request'
          it_behaves_like 'returning a todo list record'
        end

        it_behaves_like 'a request with invalid parameters'
      end

      context 'when resource does not exist' do
        let(:params) { super().merge(id: 99) }

        it_behaves_like 'a not found error'
      end
    end
  end

  describe 'destroy' do
    subject(:make_request) { delete(:destroy, params:, format:) }

    let(:params) { { id: todo_list.id } }

    it_behaves_like 'rejecting not supported mime formats'

    context 'when format is JSON' do
      before { make_request }

      context 'when resource exists' do
        let(:expected_status_code) { :no_content }

        it_behaves_like 'a successfull request'

        it 'deletes the record' do
          expect { todo_list.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when resource does not exist' do
        let(:params) { super().merge(id: 99) }

        it_behaves_like 'a not found error'
      end
    end

    context 'when record fails to be destroyed' do
      let(:expected_status_code) { :unprocessable_entity }
      let(:expected_errors) do
        "Failed to destroy TodoList with id=#{todo_list.id}"
      end

      before do
        allow_any_instance_of(TodoList)
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
