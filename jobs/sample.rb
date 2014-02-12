require "rubygems"
require "json"
require "net/http"
require "uri"

def get_data(num)
  uri = URI.parse("http://b.phodal.com/athome/"+num.to_s)
 
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
 
    response = http.request(request)

    result=JSON.parse(response.body)
    result
end

current_valuation = 0
current_karma = 0

SCHEDULER.every '2s' do
  last_valuation = current_valuation
  current_valuation = rand(100)
  current_karma=get_data(2)[0]["temperature"].to_i
  last_karma=get_data(1)[0]["temperature"].to_i
  send_event('valuation', { current: current_valuation, last: last_valuation })
  send_event('karma', { current: current_karma, last: last_karma })
  send_event('synergy',   { value: rand(100) })
end
