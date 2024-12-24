require 'rails_helper'

describe Api::TodoListsController do
  render_views

  let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

  shared_examples 'rejecting not supported mime formats' do
    context 'when format is HTML' do
      it 'raises a routing error' do
        expect { get(:index) }
          .to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end
  end

  shared_examples 'a successfull request' do
    it 'returns a success status code' do
      expect(response).to have_http_status(:success)
    end
  end

  shared_examples 'an invalid request' do
    it 'returns an error status code' do
      expect(response).to have_http_status(expected_status_code)
    end

    it 'includes an error description' do
      json_response = JSON.parse(response.body)

      expect(json_response.keys).to include('errors')
      expect(json_response['errors']).to eq(expected_errors)
    end
  end

  shared_examples 'returning a todo list record' do
    it 'returns a valid record' do
      json_response = JSON.parse(response.body)

      aggregate_failures 'includes the id and name' do
        expect(json_response.keys).to include('name', 'id')
        expect(json_response['name']).to eq(expected_todo_list.name)
        expect(json_response['id']).to eq(expected_todo_list.id)
      end
    end
  end

  describe 'GET index' do
    it_behaves_like 'rejecting not supported mime formats'

    context 'when format is JSON' do
      before { get(:index, format: :json) }

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
    it_behaves_like 'rejecting not supported mime formats'

    context 'when format is JSON' do
      before { get(:show, params:, format: :json) }

      context 'when resource does not exist' do
        let(:params) { { id: 99 } }
        let(:expected_status_code) { :not_found }
        let(:expected_errors) { 'Record not found' }

        it_behaves_like 'an invalid request'
      end

      context 'when resource exists' do
        let(:params) { { id: todo_list.id } }
        let(:expected_todo_list) { todo_list }

        it_behaves_like 'a successfull request'
        it_behaves_like 'returning a todo list record'
      end
    end
  end

  describe 'create' do
    it_behaves_like 'rejecting not supported mime formats'

    context 'when format is JSON' do
      before { post(:create, params:, format: :json) }

      let(:params) { { todolist: { name: 'Shopping List' } } }

      context 'with valid parameters' do
        let(:expected_todo_list) { TodoList.find_by!(name: 'Shopping List') }

        it_behaves_like 'a successfull request'
        it_behaves_like 'returning a todo list record'
      end

      context 'when :todolist is empty' do
        let(:params) { { todolist: {} } }
        let(:expected_status_code) { :bad_request }
        let(:expected_errors) { 'param is missing or the value is empty: todolist' }

        it_behaves_like 'an invalid request'
      end

      context 'when :name is empty' do
        let(:params) { { todolist: { name: '' } } }
        let(:expected_status_code) { :bad_request }
        let(:expected_errors) { ['Name can\'t be blank'] }

        it_behaves_like 'an invalid request'
      end
    end
  end
end
