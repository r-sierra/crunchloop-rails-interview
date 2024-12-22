class ApplicationController < ActionController::Base
  rescue_from ActionController::UnknownFormat, with: :raise_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

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
end
