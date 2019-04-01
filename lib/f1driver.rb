class F1driver

  attr_accessor :name,:first_name,:last_name, :bio, :profile_url, :status, :poles, :wins, :current_team, :teams, :nationality, :seasons

  @@all = []

  def initialize(name,first_name,last_name,profile_url)
    @name = name
    @first_name = first_name
    @last_name=last_name
    @profile_url=profile_url
    @@all<<self
  end

  def self.find_by_name(name)
    # binding.pry
    @@all.select {|driver|driver.name.include?(name.split.map(&:capitalize).join(' '))}
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

