class F1driver

  attr_accessor :name, :bio, :profile_url, :status, :poles, :wins, :current_team, :teams

  @@all = []

  def initialize(student_hash)
    student_hash.each do |a,v|
      # binding.pry
      self.send("#{a}=",v)
    end
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

