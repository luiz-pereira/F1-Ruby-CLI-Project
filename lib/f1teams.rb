require_relative "./mod_concerns"

class F1Team
  extend Findable
  include Setable
  attr_accessor :name,:bio, :profile_url, :status, :poles, :wins, :engine, :nationality, :seasons, :races,:team_principal, :drivers

  @@all = []

  def initialize(name, profile_url)
    @name = name
    @profile_url=profile_url
    @@all<<self
  end

  def include_team_for_driver
    @drivers.each do |driver|
      driver.teams<<self
    end
  end

  

  def self.all
    @@all
  end
end

