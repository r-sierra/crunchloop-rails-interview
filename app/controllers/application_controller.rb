class ApplicationController < ActionController::Base
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActionController::UnknownFormat, with: :raise_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private

  def raise_not_found
    raise ActionController::RoutingError.new('Not supported format')
  end

  def record_not_found
    respond_to do |format|
      format.json do
        render json: { errors: 'Record not found' }, status: :not_found
      end
    end
  end

  def record_invalid(exception)
    respond_to do |format|
      format.json do
        render json: {
          errors: exception.record.errors.full_messages
        }, status: :bad_request
      end
    end
  end

  def parameter_missing(exception)
    respond_to do |format|
      format.json do
        render json: {
          errors: exception
        }, status: :bad_request
      end
    end
  end
end
