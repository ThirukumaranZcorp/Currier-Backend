class Api::V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  	# def create
	#     build_resource(sign_up_params)
	#     resource.save
	#     if resource.persisted?
	#       sign_in(resource) # triggers JWT dispatch
	#       render json: {
	#         user: resource.as_json(only: [:id, :email, :name]),
	#         token: request.env['warden-jwt_auth.token']
	#       }, status: :created
	#     else
	#       render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
	#     end
	#  end

  	def create
	  build_resource(sign_up_params)
	  resource.save
	  if resource.persisted?
	    sign_in(resource, store: false) # 👈 prevents session storage
	    render json: {
	      user: resource.as_json(only: [:id, :email, :name , :role]),
	      token: request.env['warden-jwt_auth.token']
	    }, status: :created
	  else
	    render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
	  end
	end



  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    if update_resource(resource, account_update_params)
      render json: { user: resource.as_json(only: [:id, :email, :name]) }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end

  def account_update_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :current_password)
  end
end
