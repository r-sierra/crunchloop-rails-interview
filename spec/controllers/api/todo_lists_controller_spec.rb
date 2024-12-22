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

  shared_examples 'a successfull response' do
    it 'returns a success code' do
      get(:index, format: :json)

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET index' do
    it_behaves_like 'rejecting not supported mime formats'

    context 'when format is JSON' do
      before { get(:index, format: :json) }

      it_behaves_like 'a successfull response'

      it 'includes todo list records' do
        todo_lists = JSON.parse(response.body)

        aggregate_failures 'includes the id and name' do
          expect(todo_lists.count).to eq(1)
          expect(todo_lists[0].keys).to match_array(['id', 'name'])
          expect(todo_lists[0]['id']).to eq(todo_list.id)
          expect(todo_lists[0]['name']).to eq(todo_list.name)
        end
      end
    end
  end

  describe 'show' do
    it_behaves_like 'rejecting not supported mime formats'

    context 'when format is JSON' do
      context 'when resource does not exist' do
        before { get(:show, params: { id: 99 }, format: :json) }

        it 'returns an error status' do
          expect(response).to have_http_status(:not_found)
        end

        it 'includes an error description' do
          json_response = JSON.parse(response.body)

          expect(json_response.keys).to include('errors')
          expect(json_response['errors']).to eq('Record not found')
        end
      end

      context 'when resource exists' do
        before { get(:show, params: { id: todo_list.id }, format: :json) }

        it_behaves_like 'a successfull response'

        it 'includes a todo list record' do
          json_response = JSON.parse(response.body)

          aggregate_failures 'includes the id and name' do
            expect(json_response.keys).to include('name', 'id')
            expect(json_response['name']).to eq(todo_list.name)
            expect(json_response['id']).to eq(todo_list.id)
          end
        end
      end
    end
  end
end
