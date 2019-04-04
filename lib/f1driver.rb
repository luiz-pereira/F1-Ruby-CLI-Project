 require_relative "./mod_concerns"

class F1Driver

  extend Findable
  include Setable
  attr_accessor :name,:first_name,:last_name, :bio, :profile_url, :status,:races, :poles, :wins, :current_team, :teams, :nationality, :seasons,:podiums,:championships

  @@all = []

  def initialize(name,first_name,last_name)
    @name = name
    @first_name = first_name
    @last_name=last_name
    @@all<<self
  end

  def self.create_from_collection(students_array)
    # binding.pry
    students_array.each {|std|self.new(std)}
  end

  def add_student_attributes(attributes_hash)
    @twitter=attributes_hash[:twitter]
    @linkedin=attributes_hash[:linkedin]
    @github=attributes_hash[:github]
    @blog=attributes_hash[:blog]
    @profile_quote=attributes_hash[:profile_quote]
    @bio=attributes_hash[:bio]
  end

  def self.all
    @@all
  end
end

