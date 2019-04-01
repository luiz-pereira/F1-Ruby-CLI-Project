require 'colorize'
require 'io/console'

class CommandLineInterface

  def run
    drivers=[]
    drivers=ScraperWiki.scrape_list_drivers
    ScraperWiki.scrape_profiles(drivers)
    while true
      # system "clear"    
      puts "Welcome to to F1 Scraper! VRUMM, VRUMMM\n\n\n".colorize(:blue)
      list_options
      control_options(gets.chomp)
    end
  end

  def list_options
    puts "#{'1. '.colorize(:light_blue)} type 'drivers' to list all the F1 drivers since its beginning:"
    puts "\n#{'2. '.colorize(:light_blue)} type a driver's name to list all his information\n"
  end

  def control_options (selection)
    
    case selection
    when 'drivers'
      list_drivers (' ')
    when 'exit' 
      exit_application
    else
      driver = get_driver(selection)
      if driver
        puts driver.name # parei aqui
      else
        puts "Invalid driver. Please check"
      end
    end
  end

  def list_drivers(name)
    F1driver.find_by_name(name).each.with_index (1) do |driver,i| 
      puts "#{i}. #{driver.name}"
      if i%50==0
        puts "press any key to continue or 'esc' to exit"
        char=STDIN.getch
        break if char.ord == 27
      end
    end
  end

  def exit_application
    puts "\n\nThank you for using F1 Scraper.\n\n"
    exit
  end

  def get_driver(name)
    # binding.pry
    while F1driver.find_by_name(name).size>1
      puts "There are #{F1driver.find_by_name(name).size} drivers with this name. Please input the number of the driver you're looking for (or type 'back'):"
      list_drivers(name)
      choice=gets.chomp
      case choice
      when 'back'
        false
        break
      when choice.to_i > F1driver.find_by_name(name).size || choice.to_i <=0
        puts "Invalid selection."
      else
        name = F1driver.find_by_name(name)[choice.to_i-1].name
      end
      # binding.pry
      driver=F1driver.find_by_name(name)[0]
    end
    driver
  end

end



#   def make_students
#     students_array = Scraper.scrape_index_page(BASE_PATH + 'index.html')
#     Student.create_from_collection(students_array)
#   end

#   def add_attributes_to_students
#     Student.all.each do |student|
#       attributes = Scraper.scrape_profile_page(BASE_PATH + student.profile_url)
#       student.add_student_attributes(attributes)
#     end
#   end

#   def display_students
#     Student.all.each do |student|
#       puts "#{student.name.upcase}".colorize(:blue)
#       puts "  location:".colorize(:light_blue) + " #{student.location}"
#       puts "  profile quote:".colorize(:light_blue) + " #{student.profile_quote}"
#       puts "  bio:".colorize(:light_blue) + " #{student.bio}"
#       puts "  twitter:".colorize(:light_blue) + " #{student.twitter}"
#       puts "  linkedin:".colorize(:light_blue) + " #{student.linkedin}"
#       puts "  github:".colorize(:light_blue) + " #{student.github}"
#       puts "  blog:".colorize(:light_blue) + " #{student.blog}"
#       puts "----------------------".colorize(:green)
#     end
#   end

# end
