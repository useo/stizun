class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

    filter_parameter_logging :password, :password_confirmation
    helper_method :current_user_session, :current_user

  
    
    def require_user
      unless current_user
        flash[:error] = "You must be logged in."
        redirect_to new_user_session_path
        return false
      end
    end

    def require_no_user
      if current_user
        flash[:error] = "You may not be logged in before accessing this page."
        redirect_to root_path
        return false
      end
    end
    
    private
      def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
      end

      def current_user
        return @current_user if defined?(@current_user)
        @current_user = current_user_session && current_user_session.user
      end

end