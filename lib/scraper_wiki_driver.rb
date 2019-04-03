class ScraperWikiDriver

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

  def self.scrape_profiles (driver)
    attributes={}
    doc=Nokogiri::HTML(open(driver.profile_url))
    attributes[:bio]=doc.css('p').text
    attributes[:nationality]=doc.search('tr').detect{|a|a.text.include?('Nationality')}.text.gsub("Nationality ","")
    attributes[:seasons]=format_season(doc.search('tr').detect{|a|a.text.include?('Active')}.text.gsub(/Active|years/,"").split(', ').map(&:strip))
    # attributes[:championships]=data[5]
    # attributes[:wins]=data[6]
    # attributes[:poles]=data[9]
  
    teams=doc.search('tr').detect{|a|a.text.include?('Teams')}.text.split(',').map(&:strip).map{|a|a.gsub(/Teams|\d+|\[|\]/,"")}.reject(&:empty?) if !!doc.search('tr').detect{|a|a.text.include?('Teams')}
    driver.include_attributes(attributes)
  end

  def self.format_season(raw_season)
    raw_season[0] = raw_season[0][1..raw_season[0].size-1]
    season=[]
    raw_season.each do |a|
      
      if a.include?('–')
        start=a.split('–')[0].to_i
        ending=a.split('–')[1].to_i
        i=0

        while i <=(ending-start)
          season<<(start+i).to_s
          i+=1
        end
      else
        season<<a
      end
    end
    raw_season.delete_if{|a| a.include?('–')}
    season
  end

end

