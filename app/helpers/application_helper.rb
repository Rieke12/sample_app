module ApplicationHelper

    def full_title(page_title = '')
        base_title = "Ruby on Rails Tutorial Sample App"
        #page_title gets the content of the <title> tag
        if page_title.empty?
            base_title
        else
            page_title + " | " + base_title
        end
    end
    
end
