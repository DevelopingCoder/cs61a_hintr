class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    # devise_parameter_sanitizer.for(:account_update) << :name
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:password, :password_confirmation, :current_password, :name) 
    }
  end
  
  def get_file_types
    types = Set.new
    params.keys.each do |key|
      if key.match(/^.*_file$/)
        types.add(key)
      end
    end
    return types
  end
  
  def capture_type(file)
    return file.match(/(.*)_file/)[1]
  end
  
end
