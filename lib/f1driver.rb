require_relative "./mod_concerns"

class F1Driver

  extend Findable
  include Setable
  attr_accessor :name,:first_name,:last_name, :bio, :profile_url, :status,:races, :poles, :wins, :current_team, :teams, :nationality, :seasons,:podiums,:championships,:last_results, :power

  @@all = []

  def initialize(name,first_name,last_name)
    @name = name
    @first_name = first_name
    @last_name=last_name
    @last_results=[]
    @@all<<self
  end
  
  def self.all
    @@all
  end
end

