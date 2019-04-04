require 'colorize'
require 'io/console'

class CommandLineInterface

  def run
    drivers=[]
    teams = []
    drivers=ScraperWikiDriver.scrape_list_drivers #get list of all drivers
    teams=ScraperWikiTeam.scrape_wiki_teams #get list of all constructors
    
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
      driver = get_driver(selection) # this code will search for drivers containing the string
      binding.pry
      if !!driver
        ScraperWikiDriver.scrape_profiles(driver) #get driver info
        binding.pry
        # here I will show the driver stats
      else
        puts "Invalid driver. Please check"
      end
    end
  end

  def list_drivers(name)
    F1Driver.find_by_name(name).each.with_index (1) do |driver,i| 
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
    while F1Driver.find_by_name(name).size>1
      puts "There are #{F1Driver.find_by_name(name).size} drivers with this name. Please input the number of the driver you're looking for (or type 'back'):"
      list_drivers(name)
      choice=gets.chomp
      case choice
      when 'back'
        false
        break
      when choice.to_i > F1Driver.find_by_name(name).size || choice.to_i <=0
        puts "Invalid selection."
      else
        name = F1Driver.find_by_name(name)[choice.to_i-1].name
      end
      # binding.pry
    end
    driver=F1Driver.find_by_name(name)[0]
  end

end