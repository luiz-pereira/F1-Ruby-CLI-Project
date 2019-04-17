class ScraperWikiTeam

  
  def self.scrape_wiki_teams
    teams=[]
    teams=get_teams_list
    #get_constructor_profiles(teams) - I've removed this one because of performance. Will do this when needed
    #get each team profiles and insert each driver object into the team
  end

  def self.get_teams_list
    teams=[]
    doc=Nokogiri::HTML(open('https://en.wikipedia.org/wiki/List_of_Formula_One_constructors'))
    #current constructors:
    teams<<get_constructor_table(doc,'//*[@id="mw-content-text"]/div/table[2]/tbody/tr')
    
    #old_constructors
    teams<<get_constructor_table(doc,'//*[@id="mw-content-text"]/div/table[3]/tbody/tr')

    teams.flatten
  end

  def self.get_constructor_table(doc,tab)
    teams=[]
    table = doc.xpath(tab)
    table.map{|b|b.css('a')[0]}.map do |t|
      unless t.text.include?('Seasons')
        name=t.text
        profile_url='https://en.wikipedia.org' + t['href']
        team = F1Team.new(name,profile_url)
        teams<<team
      end
    end
    teams
  end

  def self.get_constructor_profiles (teams) #I will scrape every team's profile for bio and drivers
    teams.each do |team|
      attributes = scrape_team_profile(team.profile_url)
      team.include_attributes(attributes)
    end
  end

  def self.scrape_team_profile(url)
    attributes={}
    drivers=[]
    doc=Nokogiri::HTML(open(url))
    attributes
  end

  def self.scrape_results_teams
    scrape_results_teams_2018
    scrape_results_teams_2019
    format_results
  end

  def self.scrape_results_teams_2018
    doc=Nokogiri::HTML(open("https://en.wikipedia.org/wiki/2018_Formula_One_World_Championship"))
    table=doc.css('h3').detect{|a|a.text=="World Constructors' Championship standings[edit]"}.css('+table')
    team=nil
    table.css('tr').each do |t|
      unless t.text.include?('Constructor')
        if t.text.split("\n").reject(&:empty?).size ==24
          team=F1Team.find_by_url("https://en.wikipedia.org" + t.css('a').map{|a|a['href']}[1])
          team.last_results<<t.text.split("\n").reject(&:empty?).map(&:to_i).map do |a|
           a == 0 ? 20 : a
          end[2..22]
        elsif t.text.split("\n").reject(&:empty?).size ==21
          team.last_results<<t.text.split("\n").reject(&:empty?).map(&:to_i).map do |a|
            a == 0 ? 20 : a
          end[0..21]
        end
      end
    end
  end

  def self.scrape_results_teams_2019
    doc=Nokogiri::HTML(open("https://en.wikipedia.org/wiki/2019_Formula_One_World_Championship"))
    table=doc.css('h3').detect{|a|a.text=="World Constructors' Championship standings[edit]"}.css('+table')
    team=nil
    table.css('tr').each do |t|
      unless t.text.include?('Constructor')
        if t.text.split("\n").reject(&:empty?).size ==6
          team=F1Team.find_by_url("https://en.wikipedia.org" + t.css('a').map{|a|a['href']}[1])
          team=F1Team.new(t.text.split("\n").reject(&:empty?)[1].strip,"https://en.wikipedia.org" + t.css('a').map{|a|a['href']}[1]) if team == nil
          team.last_results<<t.text.split("\n").reject(&:empty?).map(&:to_i).map do |a|
            a == 0 ? 20 : a
          end[2..4]
        elsif t.text.split("\n").reject(&:empty?).size ==3
          team.last_results<<t.text.split("\n").reject(&:empty?).map(&:to_i).map do |a|
            a == 0 ? 20 : a
          end[0..2]
        end
      end
    end
  end

  def self.format_results
    teams=F1Team.all.reject{|a|a.last_results.empty?}.uniq
    teams.each do |team|
      unless team.last_results.size<3
        team.last_results[0]<<team.last_results[2]
        team.last_results[0]=team.last_results[0].flatten
        team.last_results[1]<<team.last_results[3]
        team.last_results[1]=team.last_results[1].flatten
        team.last_results=team.last_results[0..1]
      end
      team.last_results=team.last_results.transpose.map(&:sum)
      while team.last_results.size<20
        team.last_results.unshift(20)
      end
    end
  end
end

