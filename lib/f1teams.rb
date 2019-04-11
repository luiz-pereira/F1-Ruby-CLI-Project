require_relative "./mod_concerns"

class F1Team
  extend Findable
  include Setable
  attr_accessor :name,:bio, :profile_url, :status, :poles, :wins, :engine, :nationality, :seasons, :races,:team_principal, :drivers, :last_results, :power

  @@all = []

  def initialize(name, profile_url)
    @name = name
    @profile_url=profile_url
    @last_results=[]
    @@all<<self
  end

  def include_team_for_driver
    @drivers.each do |driver|
      driver.teams<<self
    end
  end

  def self.create_team_from_url(url,name)
    self.new(name,url)
  end
  

  def self.all
    @@all
  end
end

