shared_examples 'rejecting not supported mime formats' do
  context 'when format is HTML' do
    let(:format) { :html }

    it 'raises a routing error' do
      expect { make_request }
        .to raise_error(ActionController::RoutingError, 'Not supported format')
    end
  end
end

shared_examples 'a successfull request' do
  let(:expected_status_code) { :success }

  it 'returns a valid status code' do
    expect(response).to have_http_status(expected_status_code)
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

shared_examples 'a not found error' do
  let(:expected_status_code) { :not_found }
  let(:expected_errors) { 'Record not found' }

  it_behaves_like 'an invalid request'
end
