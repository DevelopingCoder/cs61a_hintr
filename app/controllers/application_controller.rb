class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: :is_devise?
  helper_method :sort_messages
  
  def is_devise?
    return params[:controller].include?("devise/")
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    # devise_parameter_sanitizer.for(:account_update) << :name
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:password, :password_confirmation, :current_password, :name) 
    }
  end
  
  def sort_messages(sort_type, messages, is_hint)
    message_upvotes = {}
    message_downvotes = {}
    messages.each do |message|
        upvotes = 0
        downvotes = 0
        if is_hint
          votes = message.hint_votes 
        else
          votes = message.votes
        end
        votes.each do |vote|
            if vote.vote_type > 0
                upvotes += 1
            elsif vote.vote_type < 0
                downvotes += 1
            end
        end
        #Negate because we sort by smallest to largest
        message_upvotes[message] = -upvotes
        message_downvotes[message] = -downvotes
    end
    
    if sort_type == "upvotes"
        messages = message_upvotes.sort_by{|_k,v| v}.map{|_k,v| k}
    elsif sort_type == "downvotes"
        messages = message_downvotes.sort_by {|_k,v| v}.map{|_k,v| k}
    end
    
  return messages
  end
  
end
