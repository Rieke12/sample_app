class MicropostsController < ApplicationController
    before_action :logged_in_user,  only: [:create, :destroy]
    before_action :correct_user,    only: :destroy

    def create
        #only allows certain attributes to be edited
        @micropost = current_user.microposts.build(micropost_params)
        if @micropost.save
            flash[:success] = "Micropost created!"
            redirect_to root_url
        else
            @feed_items = []
            #flash[:danger] = "Micropost wasn't saved!"
            #redirect_to root_url
            render 'static_pages/home'
        end
    end

    def destroy
        @micropost.destroy
        flash[:success] = "Micropost deleted"
        #request.referrer -> requests the previously visited site
        #redirect_to request.referrer || root_url
        redirect_back(fallback_location: root_url)        
    end

    private
        #only allow to edit content
        def micropost_params
            params.require(:micropost).permit(:content)
        end

        def correct_user
            @micropost = current_user.microposts.find_by(id: params[:id])
            redirect_to root_url if @micropost.nil?
        end

end
