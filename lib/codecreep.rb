$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'pry'

require 'codecreep/init_db'
require 'codecreep/github'
require 'codecreep/user'
require "codecreep/version"

module Codecreep
  class App
    def initialize
      @github = Github.new
    end

    def prompt(question, validator)
     puts question
     input = gets.chomp
     until input =~ validator
      puts "Sorry, your response was not recognized. Please re-enter your response."
      puts question
      input = gets.chomp
      end
     input
    end

    # Save GH user to the database
    def create_user(username)
      user = @github.get_user(username)
      User.find_or_create_by( login: user['login']) do |user|
                              ( user.name = user['login'],
                                user.homepage = username['url'], 
                                user.company = username['company'],
                                user.repo_count = username['public_repos'],
                                user.follower_count = username['followers'],
                                user.friend_count = username['following'] ) 
                                end                  
    end

binding.pry

    def fetch(user_list, relation, rate_limit)
      user_list.map { |user| user['login'] }.each do |user|
        limit = user.headers['x-ratelimit-remaining']
        while limit <= 5000
          self.create_user(user)
          followers = @github.get_user_info("followers", username['login'], page=1, per_page=30)
          followers.each do |user|
            self.create_user(username['login'])
          end
          following = get_user_info("following", username['login'], page=1, per_page=30)
          following.each do |user|
            self.create_user(username['login'])
          end
        end
      end
    end

    def analyze
      input = prompt("Please enter the category that you would like to view: 1: Most Popular, 2: Most Friendly, 3: Most Networked, /^[123]$/")
      if input == '1'
        puts "The following are the top 10 most popular users"
        puts "Name of User | Follower Count"
        User.order("follower_count DESC").limit(10).each do |f|
          puts "#{user.name} | #{user.follower_count}"
        end
    elsif input == '2'
      puts "The following are the top 10 Most Friendly Users"
      puts "Name of User | Number of Users Followed"
      User.order("following_count DESC").limit(10).each do |f|
        puts "#{user.name} | #{user.following_count}"
      end
    else
      puts "The top ten most Networked - Popular + Friendly"
      puts "Name of User | Total Count"
      puts "#{user.name} | #{user.follower_count + user.follower_count}"
    end
  end
end


def run
  input = prompt("Please enter 'f' to Fetch and view a list of users, or 'a' to Analyze user data?, /^[fa]$/")
      if input == "f"
        users = prompt("Please enter the name of the users that you would like to fetch\n"\
                       " Each user must be seperated by a comma and a space, ex: Jane, Joe, etc.:", 
                       /^(\w+[,]\s)+\w+$|^\w+$/)
        user_list = users.split(", ")
        self.fetch(user_list)
      else
        self.analyze
      end
    end

# users = ["rupert0", "aerique", "thezerobit", "nfunato", "qinhanlei", "bsmr", "jisaacks", "wtiger", "tsnow", "m0nkey"]
# binding.pry

app = Codecreep::App.new
# binding.pry
end
