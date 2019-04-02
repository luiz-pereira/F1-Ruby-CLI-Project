require 'nokogiri'
require 'open-uri'
require 'pry'

class ScraperWiki

  def self.scrape_list_drivers
    drivers=[]
    doc=Nokogiri::HTML(open('https://en.wikipedia.org/wiki/List_of_Formula_One_drivers'))
    table = doc.xpath('//*[@id="mw-content-text"]/div/table[3]')
    table.search('tr').css('span.fn').each do |d|
     name = d.text
     first_name = d.text.split(' ').first
     last_name = d.text.split(' ').last
     profile_url='https://en.wikipedia.org' + d.css('a').map{|a|a['href']}[0]
     driver=F1Driver.new(name,first_name,last_name,profile_url)
     drivers<<driver
    end
    drivers
  end

  def self.scrape_wiki_teams
    teams=[]
    teams=get_teams_list
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

  def self.scrape_profiles (drivers)
    attributes={}
    drivers.each do |d|
      doc=Nokogiri::HTML(open(d.profile_url))
      attributes[:bio]=doc.css('p').text
      data=doc.search('td').map(&:text)
      attributes[:nationality]=data[1].strip
      attributes[:seasons]=format_season(data[2])
      attributes[:championships]=data[5]
      attributes[:wins]=data[6]
      attributes[:poles]=data[9]
    

      # attributes[:teams]=doc.search('table.biography.vcard td').map do |a|
      #   binding.pry
      #   a 
        
      # end[1].text.split(',').map(&:strip)
    end
  end

  def self.format_season(raw_seasons)
    season = raw_seasons.split(',').map{|a|a.strip}
    season.each do |a| 
      if a.include?('–')
        start=a.split('–')[0].to_i
        ending=a.split('–')[1].to_i
        i=0
        while i <=(ending-start)
          season<<(start+i).to_s
          i+=1
        end
      end
    end
    season.delete_if{|a| a.include?('–')}
    season
  end

end

