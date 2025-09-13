class ApplicationController < ActionController::API
    respond_to :json

    before_action :set_default_format

    private

    def set_default_format
        request.format = :json
    end
end
