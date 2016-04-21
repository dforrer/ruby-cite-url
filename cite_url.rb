#!/usr/bin/ruby

require "rubygems"
require "nokogiri"
require "open-uri"
require "uri"
require "whois"
require "uri/http"
require "public_suffix"

# http://stackoverflow.com/questions/17741474/how-to-squish-in-ruby
class String
  def squish!
    gsub!(/\A[[:space:]]+/, '')
    gsub!(/[[:space:]]+\z/, '')
    gsub!(/[[:space:]]+/, ' ')
    self
  end
end

# Copy input to clipboard on mac os x
def pbcopy(input)
  str = input.to_s
  IO.popen('pbcopy', 'w') { |f| f << str }
  str
end

# accept command line arguments
PAGE_URL = ARGV[0]

uri = URI.parse( PAGE_URL )
domain = PublicSuffix.parse(uri.host)

#puts "Domain: #{domain.domain}"

c = Whois::Client.new
r = c.lookup( domain.domain )

#puts r

# grab the page title
begin
  page = Nokogiri::HTML(open(PAGE_URL))
  title = page.css('title')[0].nil? ? "(OHNE TITEL)" : page.css('title')[0].text
rescue
  puts "=========================================="
  puts "ERROR opening URL - citation incomplete!!!"
  puts "=========================================="
  title = "PAGE NOT FOUND"
end 

title = title.squish!

# "Pi Supply, "Pi PoE Switch HAT", 2016. [Online]. Verfügbar: https://www.pi-supply.com/product/pi-poe-switch-hat-power-over-ethernet-for-raspberry-pi/. [Zugriff am 09.04.2016]"

source = r.admin_contacts.try(:first).try!(:[], :organization) || domain.domain.capitalize
source = domain.domain.capitalize if source.empty?

final = "#{source}, \"#{title}\", #{Time.now.strftime("%Y")}. [Online]. Verfügbar: #{PAGE_URL}. [Zugriff am #{Time.now.strftime("%d.%m.%Y")}]."

puts final
pbcopy(final)