require 'httparty'
require 'pry'

module Codecreep
  class Github
    include HTTParty
    base_uri 'https://api.github.com'
    # read_timeout 3600
    basic_auth ENV['GH_USER'], ENV['GH_PASS']

    def get_users(username)
      self.class.get("/users/#{username}")
    end

    def display_user_list(username)
        user = self.get_users(username)
        user_info = { name: user['user'], 
                      homepage: user['url'], 
                      company: user['company'],
                      repo_count: user['public_repos'],
                      follower_count: user['followers'],
                      friend_count: user['following'] }
        User.find_or_create_by(user_info)
        puts user_info
    end
binding.pry
    def get_user_info_from_list(user_list, rate_limit)
      limit = self.get_rate_limit
      while limit <= 5000
          user_list.each do |user|
            self.display_user_list(user)
            followers = get_related_users(user, "followers")
            followers.each do |follower|
              self.display_user_list(follower)
            end
            following = get_related_users(user, "following")
            following.each do |follow|
              self.display_user_list(following)
            end
          end
      end
    end

    def get_related_users(username, relation, page=1)
        options = {
          query: {page: page}
        }
        self.class.get("/users/#{username}/#{relation}", options)
    end

    def list_total_related_users(username)
        user_list = []
        page = 1
        response = self.get_related_users(username, relation, page)
        while response.length != 0
          user_list += response.map { |x| x['login']  }
          page += 1
          response = self.get_related_users(username, relation, page)
        end
        user_list + response.map { |x| x['login']  }
      end

    def get_rate_limit
      self.class.get("/rate_limit")
    end
    binding.pry
  end
end
