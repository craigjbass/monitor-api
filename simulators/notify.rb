require 'json'
require 'sinatra'
$stdout.sync = true

post '*' do
  puts "**********"
  puts "PROJECT URL:"
  puts JSON.parse(request.body.read)["personalisation"]["access_url"]
  puts "**********"

  content_type 'application/json'
  response.body = {}.to_json
  200
end
