require 'colorize'
require 'io/console'

class CommandLineInterface

  def run
    drivers=[]
    teams = []
    drivers=ScraperWikiDriver.scrape_list_drivers #get list of all drivers
    teams=ScraperWikiTeam.scrape_wiki_teams #get list of all constructors
    ScraperWikiTeam.scrape_results_teams
    ScraperWikiDriver.scrape_results_drivers

    while true
      system "clear"    
      puts "Welcome to to F1 Scraper! VRUMM, VRUMMM\n\n\n".colorize(:blue)
      list_options
      control_options(gets.chomp)
    end
  end

  def list_options
    puts "#{'1. '.colorize(:light_blue)} type 'drivers' to list all the F1 drivers since its beginning:"
    puts "\n#{'2. '.colorize(:light_blue)} type a driver's name to list all his information\n\n"
  end

  def control_options (selection)
    
    case selection
    when 'drivers'
      list_drivers (' ')
    when 'exit' 
      exit_application
    else
      driver = get_driver(selection) # this code will search for drivers containing the string
      if !!driver
        ScraperWikiDriver.scrape_profiles(driver) #get driver info
        show_driver_stats(driver)
      else
        puts "\n\nInvalid driver. Please check."
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
    end
    driver=F1Driver.find_by_name(name)[0]
  end

  def show_driver_stats (driver)
    system "clear"
    puts draw_border("*")
    puts draw_box_name(driver.name)
    if driver.status=="Active"
      puts draw_line_one_stat(driver.current_team.name)
    else
      puts draw_line_one_stat("Retired since #{driver.seasons.last}")
    end
    puts draw_empty_line("/")
    puts draw_line_two_stat("Races",driver.races,"Podiums", driver.podiums)
    puts draw_line_one_stat("Wins: #{driver.wins}") if driver.wins.to_i>0
    puts (draw_empty_line("/") + draw_line_one_stat("Championships: #{driver.championships}")) if driver.championships.to_i>0
    puts draw_empty_line("/")
    puts draw_line_one_stat("Seasons: #{unformat_seasons(driver.seasons).join(", ")}")
    puts draw_line_one_stat("Teams:")
    puts draw_empty_line("/")
    driver.teams.each{|a|puts draw_line_one_stat(a.name)}
    # binding.pry
    puts draw_border("*")
    puts condense_text(driver.bio,50)
    
    if driver.current_team
      puts "\n\n\nThis driver is still Active. Do you want to see a prediction for the next race?"
      ans=gets.chomp
      if ans=='Yes' || ans=='y' || ans=='yes'
        drivers =F1Driver.all.select{|a|a.status=="Active"}
        ScraperWikiDriver.scrape_profiles_mult(drivers)
        pred=Predictor.new
        pred.calc_power(drivers,driver)
      end
    else
      STDIN.getch
    end
    

  end

  def draw_border (symbol)
    str=symbol*50 + "\n"
  end  

  def draw_empty_line (symbol)
    str=symbol + " "* 48 + symbol + "\n"
  end

  def draw_box_name(name)
    str="/" + (" " * ((24-(name.size/2).to_i-1))) + ("."* (name.size+2)) + " " * ((24-(name.size/2).to_i-(1+name.size%2))) + "/\n" + "/" + (" " * ((24-(name.size/2).to_i-1))) + "|" + name + "|" + " " * ((24-(name.size/2).to_i-(1+name.size%2))) + "/\n" + "/" + (" " * ((24-(name.size/2).to_i-1))) + ("^"* (name.size+2)) + " " * (24-(name.size/2).to_i-(1+name.size%2)) + "/"
  end

  def draw_line_one_stat(stat)
    str="/" + (" " * ((24-(stat.size/2).to_i))) + stat + " " * ((24-(stat.size/2).to_i-(stat.size%2))) + "/"
  end

  def draw_line_two_stat(label1, stat1, label2, stat2)
    stat=""
    stat = label1 + ": " + stat1 + " " * 6 + label2 + ": " + stat2
    str=draw_line_one_stat(stat)
  end

  def condense_text(text,space)
    cond_text=""
    for i in 0..(text.size-1) do
      cond_text+=text[i]
      if i%49==0 && i!=0
        cond_text+="\n" 
      end
    end
    cond_text
  end

  def unformat_seasons(seasons)
    cond_seasons=[]
    beg_year=seasons.first
    i=0
    while i<seasons.size-1
      beg_year=seasons[i]
      cur_year=beg_year
      while cur_year.to_i+1==seasons[i+1].to_i
        i+=1
        cur_year=seasons[i]
      end
      cur_year==beg_year ? cond_seasons<<beg_year : cond_seasons<< (beg_year + "-" + cur_year)
      i+=1
    end
    cond_seasons
  end

end