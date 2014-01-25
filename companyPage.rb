#require 'selenium-webdriver'
require 'csv'

=begin
class IndustryList
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

class CompanyPage
  
  def initialize(:id, :url, :jobclass, :jobid)
    @id, @companyurl, @companyjobclass, @companyjobid = :id, :url, :jobclass, :jobid
  end
  
    SeleniumWorker.new(@companyurl, @companyjobclass, @companyjobid)
  end
  
  def count
  end
  
  def titles
  end
  
  def urls
  end
  
end

class SeleniumWorker
  def initialize(url, jobclass, jobid)
    driver = Selenium::WebDriver.for :firefox
    driver.navigate.to url
    if jobclass.length > 0 && jobid.length > 0 then
      @@element = driver.find_element(:class = jobclass, :id = jobid)
    elsif jobclass.length > 0 && jobid.length == 0 then
      @@element = driver.find_element(:class = jobclass)
    elsif jobclass.length == 0  && jobid.length > 0 then
      @@element = driver.find_element(:id = jobid)
    end
    driver.quit
  end
  
end

company = CompanyPage.new('','','','222')
