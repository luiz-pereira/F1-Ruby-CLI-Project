require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students=[]
    doc=Nokogiri::HTML(open(index_url))
    doc.css('div.student-card').each do |student|
      students<<{
                name:student.css('h4').text,
                location:student.css('p').text,
                profile_url:student.css('a').map {|a|a['href']}.join('')
              }   
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc=Nokogiri::HTML(open(profile_url))
    
    student={
      bio:doc.css('div.bio-content.content-holder div.description-holder').text.strip,
      profile_quote:doc.css('div.profile-quote').text
    }
    doc.css('div.social-icon-container a').each do |a|
      case a['href'].split('/')[2]
      when 'github.com'
        student[:github]=a['href']
      when 'www.linkedin.com'
        student[:linkedin]=a['href']
      when 'www.youtube.com'
        student[:youtube]=a['href']
      when 'twitter.com'
        student[:twitter]=a['href']
      else
        student[:blog]=a['href']
      end 
    end 
    student
  end

end

