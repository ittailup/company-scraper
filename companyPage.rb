require 'selenium-webdriver'
require 'csv'
require 'uri'

=begin
class IndustryList < Array
  def initialize(companies)
    # should point to csv
    companies = []
    CSV.open(companies, 'r') do |csv|
      csv.each do |row|
        CompanyPage.new(row[0], row[1], row[2], row[3])
    end
      @listcompanies = companies
  end
end
=end


class CompanyPage < Array 
  attr_reader :url
  def initialize(url, xpath)
    @url = url
    @page = SeleniumWorker.new(url, xpath)     
  end
  
  def count
    @page.elements.count
  end

  def titles
    atext = []
    @page.elements.each do |link|
      atext << link.text
    end
    return atext
  end
  
  def urls
    urls = []
     @page.elements.each do |link|
       urls << link.attribute("href") unless link.attribute("href").nil?
     end
     return urls
  end
  
  def quit
    @page.driver.quit
  end
end

class SeleniumWorker < Selenium::WebDriver::Driver
  def initialize(url, xpath)
    if $driver.nil?
      $driver = Selenium::WebDriver.for :firefox
      @driver = $driver
    else
      @driver = $driver
    end  
    @driver.navigate.to url
    @elements = @driver.find_elements(:xpath, xpath)
    return @driver.find_elements(:xpath, xpath)
  end
  
  def elements
    return @elements
  end
    
  def driver
    return @driver
  end
    
end
  

#data = SeleniumWorker.new("http://500px.com/jobs", "//a[contains(@class, 'resumator-hide-details')]").text 
data = CompanyPage.new('http://youilabs.com/who-we-are/working-at-youi/','//div[contains(@class, "careertext")]//a')

p data.url

data.quit
#company = CompanyPage.new('http://500px.com/jobs','','resumator-job-link resumator-jobs-text','')
