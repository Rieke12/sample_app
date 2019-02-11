module UsersHelper

    def gravatar_for(user, options = {size: 80})
        #can be used to create free user imgs
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        #size will be defined in the calling method
        size = options[:size]
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
        #creatses <img> tag
        image_tag(gravatar_url, alt: user.name, class: "gravatar")
    end
end
