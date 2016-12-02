class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: :is_devise?
  helper_method :sort_messages
  helper_method :aggregate_changes
  helper_method :eval_confirmed_changes
  
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
        messages = message_upvotes.sort_by{|_k,v| v}.map{|k,_v| k}
    elsif sort_type == "downvotes"
        messages = message_downvotes.sort_by {|_k,v| v}.map{|k,_v| k}
    end
    
    return messages
  end
  
  def aggregate_changes
    changes = {}
    confirmed_additions = params[:confirmed_additions]
    additions = []
    if confirmed_additions
        confirmed_additions.each do |addition|
            additions += [eval(addition)]
        end
    end
    changes[:additions] = additions
    
    confirmed_deletions = params[:confirmed_deletions]
    deletions = []
    if confirmed_deletions
        confirmed_deletions.each do |deletion|
            deletions += [eval(deletion)]
        end
    end
    changes[:deletions] = deletions
    
    confirmed_edits = params[:confirmed_edits]
    edits = []
    if confirmed_edits 
        confirmed_edits.each do |edit|
            edits += [eval(edit)]
        end
    end
    changes[:edits] = edits
    
    return changes
  end
  
  def show_changes(model, format_msg)
    if not params.keys.include?("path")
        flash[:notice] = "Oops we lost your state. Please upload again"
        redirect_to upload_path and return
    end
    changes = model.import(params[:path])
    if not changes
        flash[:notice] = format_msg
        redirect_to upload_path and return
    elsif changes.key? :error
        @error = changes[:error]
    end
    
    #Otherwise Successful
    @additions = changes[:additions]
    @deletions = changes[:deletions]
    @edits = changes[:edits]
  end
  
  def eval_confirmed_changes(confirmed_changes)
    changes = []
    if confirmed_changes
      confirmed_changes.each do |change|
        changes += [eval(change)]
      end
    end
    return changes
  end
  
end
