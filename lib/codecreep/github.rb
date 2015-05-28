require 'httparty'

module Codecreep
  class Github
    include HTTParty
    base_uri 'https://api.github.com'
    read_timeout 3600
    basic_auth ENV['GH_USER'], ENV['GH_PASS']

    def rate_limit
      self.class.get(rate_limit)
    end

    def rate_limit_info( )

    def get_users(user_name)
      self.class.get("/users/#{user_name}")
    end

    def get_user_data(user_name)
      response = self.get_user_info(user_name)
      response.values.map {|v| "#{key}=#{v}"}
    end.join('&')
  }
    end

    def list_user_info(user_name)
    end

 end   
      
end

