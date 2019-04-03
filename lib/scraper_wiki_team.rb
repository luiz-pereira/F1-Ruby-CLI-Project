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
    drivers=doc.search('tr').detect{|a|a.text.include?('Race drivers')}.text.split('.').drop(1).map(&:strip).map{|a|a.gsub(/\d+|\[|\]/,"")}.reject(&:empty?) if !!doc.search('tr').detect{|a|a.text.include?('Race drivers')}
    attributes[:drivers]=drivers.map{|driver|F1Driver.find_by_name(driver)}.flatten unless drivers==[]
    # attributes[:team_principal]=doc.search('tr').detect{|a|a.text.include?('Team principal')}.text.gsub("Team principal(s)","").gsub(/d+|\[|\]|\d/,"")
    #attributes[:races]=doc.search('tr').detect{|a|a.text.include?('Races entered')}.text.gsub(/\D/,"")
    attributes
  end

  

end

