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
    # 2018
    doc=Nokogiri::HTML(open("https://en.wikipedia.org/wiki/2018_Formula_One_World_Championship"))
    table=doc.css('h3').detect{|a|a.text=="World Constructors' Championship standings[edit]"}.css('+table')
    team=nil
    table.css('tr').each do |t|
      unless t.text.include?('Constructor')
        if t.text.split("\n").reject(&:empty?).size ==24
          team=F1Team.find_by_url("https://en.wikipedia.org" + t.css('a').map{|a|a['href']}[1])
          team.last_results=[]
          team.last_results<<t.text.split("\n").reject(&:empty?).map(&:to_i)[2..22]
        elsif t.text.split("\n").reject(&:empty?).size ==21
          team.last_results<<t.text.split("\n").reject(&:empty?).map(&:to_i)[0..21]
        end
      end
    end

    # 2019
    doc=Nokogiri::HTML(open("https://en.wikipedia.org/wiki/2019_Formula_One_World_Championship"))
    table=doc.css('h3').detect{|a|a.text=="World Constructors' Championship standings[edit]"}.css('+table')
    team=nil
    table.css('tr').each do |t|
      unless t.text.include?('Constructor')
        if t.text.split("\n").reject(&:empty?).size ==5
          team=F1Team.find_by_url("https://en.wikipedia.org" + t.css('a').map{|a|a['href']}[1])
          team=F1Team.new(t.text.split("\n").reject(&:empty?)[1].strip,"https://en.wikipedia.org" + t.css('a').map{|a|a['href']}[1]) if team == nil
          team.last_results=[] unless team.last_results
          team.last_results<<t.text.split("\n").reject(&:empty?).map(&:to_i)[2..3]
        elsif t.text.split("\n").reject(&:empty?).size ==2
          team.last_results<<t.text.split("\n").reject(&:empty?).map(&:to_i)[0..1]
        end
      end
    end
  end
end

