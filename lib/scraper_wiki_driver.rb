class ScraperWikiDriver

  def self.scrape_list_drivers
    attributes={}
    drivers=[]
    doc=Nokogiri::HTML(open('https://en.wikipedia.org/wiki/List_of_Formula_One_drivers'))
    table = doc.xpath('//*[@id="mw-content-text"]/div/table[3]')
    table.search('tr').map do |a|
      unless a.text.include?('Points[Note]')
        name = a.css('td[1]').text.chomp.gsub(/\d+|[\*\[\^\~]/,"")
        first_name = name.split(' ').first
        last_name = name.split(' ').last
        driver=F1Driver.new(name,first_name,last_name)
        drivers<<driver
        
        attributes[:nationality]=a.css('td[2]').text.chomp.gsub(/[[:space:]]/,'')
        attributes[:seasons]=format_season(a.css('td[3]').text.chomp.split(','))
        attributes[:seasons].last==Date.today.year.to_s ? attributes[:status]="Active" : attributes[:status]="Retired"
        attributes[:championships]=a.css('td[4]').text.chomp[0]
        attributes[:races]=a.css('td[5]').text.chomp
        attributes[:wins]=a.css('td[8]').text.chomp
        attributes[:poles]=a.css('td[7]').text.chomp
        attributes[:podiums]=a.css('td[9]').text.chomp
        attributes[:profile_url]='https://en.wikipedia.org' + a.css('td[1] span.fn a').map{|a|a['href']}[0] unless a.css('td[1] span.fn a').map{|a|a['href']}[0]==nil
        driver.include_attributes(attributes)
      end
    end
    drivers
  end

  def self.scrape_profiles (driver)
    attributes={}
    teams=[]
    doc=Nokogiri::HTML(open(driver.profile_url))
    
    # test way of finding table
    if !!doc.search('h2').detect {|a|a.text.include?('Formula One') && a.text.include?('results')}
      selector='h2'
    elsif !!doc.search('h3').detect {|a|a.text.include?('Formula One') && a.text.include?('results')}
      selector='h3'
    end

    doc.search("#{selector}").each do |a|
      if a.text.include?('Formula One') && a.text.include?('results')
        table = a.css('+p+table')
        teams=[]
        table.css('tr').each do |line|
          unless line.css('th[3]').text=="Chassis\n"
            line.css('th[2] a').map do |r|
              F1Team.create_team_from_url('https://en.wikipedia.org' + r['href'],line.css('th[2] a').text) unless F1Team.find_by_url('https://en.wikipedia.org' + r['href'])
              teams<<F1Team.find_by_url('https://en.wikipedia.org' + r['href'])
            end
          end
        end
      end
    end
    
    attributes[:teams]=teams.uniq
    attributes[:bio]=doc.css('p').map(&:text)[1].gsub(/\[\d+\]/,"")
    attributes[:current_team]=teams.last if driver.status=='Active'
    
    driver.include_attributes(attributes)
  end

  def self.format_season(raw_season)
    # raw_season[0] = raw_season[0][1..raw_season[0].size-1]
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

