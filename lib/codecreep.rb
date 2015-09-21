$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'pry'

require 'codecreep/init_db'
require 'codecreep/github'
require "codecreep/version"
require "codecreep/user"


module Codecreep
  class App
    def initialize
      @github = Github.new
      @user = nil
    end

    def prompt(question, validator)
     puts question
     input = gets.chomp
     until input =~ validator
      puts "Sorry, wrong answer."
      puts question
      input = gets.chomp
      end
     input
     if input == "Fetch"
        fetch
      else
        analyze
      end
    end

    def get_user_names
      # reconfigure to put fetch and analyze options here
      user_choice = prompt("Please enter 'Fetch' to view a list of users, or 'Analyze to analyze user data?, /^\w+$/")
      
      username = prompt("Please enter the Github usernames of the users that you would like to view. Ex: smitch, jjackson, etc., /^\w+$/")
      result = username.split(",")
    end

    def fetch(username)
      user_list = self.get_user_names
      @github.create_users_from_list(user_list, rate_limit)
      end
    end

    def analyze
      puts "\n\n"
      puts "Most Popular: "
      self.
      puts "\n\n"
      puts "Most Friendly: "
      @github
      puts "\n\n"
      puts "Most Networked"
    end

    def most_number_of_users_following
      users = User.order(follower_count: :desc).limit(10)
      puts "Name of User | Most Followers"
      users.each do |user|
        puts "#{user.name} | #{user.follower_count}"
      end
    end

    def most_number_of_users_followed
      users = User.order(following_count: :desc).limit(10)
      puts "Name of User | Most Users Followed"
      users.each do |user|
        puts "#{user.name} | #{user.following_count}"
      end
    end

   def most_followed
       users = User.order(follower_count: :desc).limit(10)
      puts "User | Most Followers"
      users.each do |user|
      puts "#{user.name} | #{user.follower_count}"
       end
    end

    def most_networked
      users = User.order('follower_count + following_count DESC').limit(10)
      puts "Name of User | Most Networked"
      users.each do |user|
        puts "#{user.name} | #{user.follower_count + user.follower_count}"
      end
    end

# users = ["rupert0", "aerique", "thezerobit", "nfunato", "qinhanlei", "bsmr", "jisaacks", "wtiger", "tsnow", "m0nkey"]
# binding.pry

app = Codecreep::App.new
# binding.pry
end
