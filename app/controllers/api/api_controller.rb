module Api
  class ApiController < ActionController::API
    ACCEPTED_MIME_TYPES = %i[json].freeze

    private_constant :ACCEPTED_MIME_TYPES

    before_action :verify_requested_format!

    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from ActionController::UnknownFormat, with: :raise_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ActiveRecord::RecordNotDestroyed, with: :record_not_destroyed
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    private

    def verify_requested_format!
      collector = ActionController::MimeResponds::Collector.new(
        ACCEPTED_MIME_TYPES,
        request.variant
      )

      raise ActionController::UnknownFormat unless collector.negotiate_format(
        request
      )
    end

    def parameter_missing(exception)
      render_json_error(exception, :bad_request)
    end

    def record_invalid(exception)
      render_json_error(exception.record.errors.full_messages, :bad_request)
    end

    def raise_not_found
      raise ActionController::RoutingError, 'Not supported format'
    end

    def record_not_destroyed(exception)
      render_json_error(exception, :unprocessable_entity)
    end

    def record_not_found
      render_json_error('Record not found', :not_found)
    end

    def render_json_error(errors, status)
      render(json: { errors: }, status:)
    end
  end
end
