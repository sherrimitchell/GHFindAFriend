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
    end

    def confirm?(question)
      answer = prompt(question, /^[yn]$/i)
      answer.upcase == 'Y'
    end

    binding.pry

    def get_user_choice
      user_choice = prompt("Please enter 'Fetch' to view a list of users, or 'Analyze to analyze user data?, /^\w+$/")
      if input == "Fetch"
        fetch
      else
        analyze
      end
    end

    def get_user_names
      username = prompt("Please enter the Github usernames of the users that you would like to view. Ex: smitch, jjackson, etc., /^\w+$/")
      result = username.split(",")
    end
binding.pry
    def fetch(username)
      user_list = @github.get_user_names
      @github.display_user_list(user_list, rate_limit)
      end
    end

    def analyze
      if User.any?
        puts "\n\n"
        puts "Most Popular: "
        self.most_number_of_users_following
        puts "\n\n"
        puts "Most Friendly: "
        self.most_followed
        puts "\n\n"
        puts "Most Networked"
        puts most_networked
      else
        self.get_user_names
      end
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
