require 'httparty'
require 'pry'

module Codecreep
  class Github
    include HTTParty
    base_uri 'https://api.github.com'
    # read_timeout 3600
    basic_auth ENV['GH_USER'], ENV['GH_PASS']

    # Get user by GH user ID
    def get_user(username)
      result = self.class.get("/users/#{username}", headers: @headers)
    end

    def get_user_info(status, username, page=1, per_page=30)
      options = {
                  headers: @headers, 
                  query: {page: page, per_page: per_page}
                }

            result = self.class.get("/users/#{username}#{status}", options)
    end

    # Get the followers for a user
    def get_followers(username, page=1, per_page=30)
      get_user_info("/followers", username, page, per_page)
    end

    # Get a list of the users that a user is following
    def get_following(username, page=1, per_page=30)
      get_user_info("/following", username, page, per_page)
    end

    binding.pry
  end
end