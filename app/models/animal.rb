class Animal < ActiveRecord::Base
    validates_presence_of :name, :species
    belongs_to :zookeeper
end