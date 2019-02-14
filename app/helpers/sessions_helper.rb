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
        #only execute if session has user_id, stores in variable for single access
        if (user_id = session[:user_id])
            #store in variable, to only acces db once
            # ||= used in order to only find user, in case variable isn't set
            @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.signed[:user_id])
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end

    def remember(user)
        user.remember
        #permanent = 20 years, signed = encrypted
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    #forgets a persistent session
    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    #logs out the current user
    def log_out
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end


    #returns true if the user is logged in, false otherwise
    def logged_in?
        !current_user.nil?
    end

    # Redirects to stored location (or to the default)
    def redirect_back_or(default)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
    end

    #stores url trying to be accessed
    def store_location
        #only stores url if requested through GET
        session[:forwarding_url] = request.original_url if request.get?
    end
end
