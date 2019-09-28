class Movie < ActiveRecord::Base
    # define all the ratings we will record
    def self.all_ratings
        %w(G PG PG-13 NC-17 R)
    end
end
