require 'io/console'
require 'colorize'

class Predictor

    # calculate a drivers power

    def calc_power(drivers,current_driver)
        calc_teams(drivers.map(&:current_team).uniq)
        calc_drivers(drivers)
        draw_grid(drivers.sort_by(&:power).map(&:name),current_driver)
    end

    def calc_teams(teams)
        teams.each do |team|
            points=add_points_team(team)
            team.power=points
        end
    end

    def add_points_team(team)
        calc_race_history(team.last_results,40)+(momentum_points(team,40))
    end

    def calc_drivers(drivers)
        drivers.each do |driver|
            points=add_points_driver(driver)
            driver.power=points
        end
    end

    def add_points_driver(driver)
        calc_race_history(driver.last_results,20)+(driver.championships.to_i*10)+(momentum_points(driver,20))+(driver.podiums.to_i*0.5)+(driver.wins.to_i)+driver.current_team.power
    end


# the methods below apply to both teams and drivers

    def momentum_points (item,total)
        points =(total-item.last_results.last)*10
        points
    end

    def calc_race_history(item,total)
        point=0
        item.reverse.each_with_index do |a,i|
            if i<2
                point+=((total-a)*(10-i))
            elsif i<5
                point+=((total-a)*(5-i))
            end
        end
        point
    end

    def draw_grid(ranking,cur_driver)
        system "clear"
        ranking.reverse.each_with_index do |driver,i|
            puts "\n"
            if i%2==0
                # puts "|" + " " * 30 + "|"
                if driver==cur_driver.name
                    puts "|" + (" " * ((30-driver.size)/2).to_i) + driver.colorize(:red) + (" " * ((30-driver.size)/2.to_i+(driver.size%2)))+"|" +"#{i+1}".colorize(:blue)    
                else
                    puts "|" + (" " * ((30-driver.size)/2).to_i) + driver + (" " * ((30-driver.size)/2.to_i+(driver.size%2)))+"|"+"#{i+1}".colorize(:blue)    
                end
                puts "|" + "_" * 30 + "|"
            else
                # puts " " * 40 + "|" + " " * 30 + "|"
                if driver==cur_driver.name
                    puts " " * 40 + "|" + (" " * ((30-driver.size)/2).to_i) + driver.colorize(:red) + (" " * ((30-driver.size)/2.to_i+(driver.size%2)))+"|"+"#{i+1}".colorize(:blue)    
                else
                    puts " " * 40 + "|" + (" " * ((30-driver.size)/2).to_i) + driver + (" " * ((30-driver.size)/2.to_i+(driver.size%2)))+"|"+"#{i+1}".colorize(:blue)    
                end
                puts " " * 40 + "|" + "_" * 30 + "|"
            end
        end
        puts "Press any key to go back"
        STDIN.getch
    end

end