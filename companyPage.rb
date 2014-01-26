require 'selenium-webdriver'
require 'csv'
require 'uri'


class IndustryList < Array
    def initialize(companies)
    # should point to csv for loading
      @companies = []
      CSV.open(companies, 'r', col_sep: '"') do |csv|
        csv.each do |row|
          p row[2]
          @companies << [row[0], row[1], row[2]]
        end  
      end
    end
    
    def to_csv
      today = Date.today.strftime("%Y-%m-%d")
      mainfile = 'results-%s.csv' % [today]
      
      CSV.open(mainfile, 'wb') do |listcsv|
        @companies.each do |args|
          @page = CompanyPage.new(args)
          companyfile = 'results-%s-%s.csv' % [@page.name, today]
          CSV.open(companyfile, 'wb') do |companycsv|
            combined = []
            @page.titles.each do |title|
              combined << [title]
            end
            @page.listingurls.each_with_index do |url, index|
              combined[index] << [url]
            end
            combined.each do |listingurl|
              companycsv << listingurl
            end
          end
          listcsv << [@page.name, @page.count]
        end
      end
      @page.quit
    end
    
            
end


class CompanyPage
  attr_accessor :name, :url, :count, :titles, :listingsurls
  def initialize(args)
    @name = args[0]
    @url = args[1]
    @xpath = args[2]
    @page = SeleniumWorker.new(args[1], args[2]) 
    @count = @page.elements.count
    @titles = self.titles
    @listingurls = self.listingurls
  end


  def titles
    atext = []
    @page.elements.each do |link|
      atext << link.text
    end
    return atext
  end
  
  def listingurls
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
  

#data = CompanyPage.new("http://500px.com/jobs", "//a[contains(@class, 'resumator-hide-details')]").text 
#data = CompanyPage.new('001', 'http://youilabs.com/who-we-are/working-at-youi/','//div[contains(@class, "careertext")]//a')

data = IndustryList.new('startups.txt')
data.to_csv
#company = CompanyPage.new('http://500px.com/jobs','','resumator-job-link resumator-jobs-text','')
