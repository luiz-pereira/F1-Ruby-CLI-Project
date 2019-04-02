require_relative "./mod_concerns"

class F1Team
  extend Findable
  attr_accessor :name,:bio, :profile_url, :status, :poles, :wins, :engine, :nationality, :seasons, :races

  @@all = []

  def initialize(name, profile_url)
    @name = name
    @profile_url=profile_url
    @@all<<self
  end

  def self.all
    @@all
  end
end

