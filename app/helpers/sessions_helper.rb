module SessionsHelper

    #logs in the given user
    def log_in(user)
        #session creates temp cookie (deleted when browser is closed)
        #automatically encrypted
        #cookie would create lasting cookie without encryption
        session[:user_id] = user.id
    end

    #returns the current logged-in user
    def current_user
        #only execute if session has user_id
        if session[:user_id]
            #store in variable, to only acces db once
            # ||= used in order to only find user, in case variable isn't set
            @current_user ||= User.find_by(id: session[:user_id])
        end
    end

    #returns true if the user is logged in, false otherwise
    def logged_in?
        !current_user.nil?
    end

    def log_out
        session.delete(:user_id)
        @current_user = nil
    end

end
