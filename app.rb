require 'yajl'
require 'active_support'
require 'librato-metrics'
require 'scrolls'

module P2met
  class App < Sinatra::Base
    get '/' do
      "200\n"
    end

    post '/submit' do
      librato_user  = params[:librato_user] || ENV['LIBRATO_USER']
      librato_token = params[:librato_token] || ENV['LIBRATO_TOKEN']

      client = Librato::Metrics::Client.new
      client.authenticate(librato_user.to_s.strip, librato_token.to_s.strip)

      payload = HashWithIndifferentAccess.new(Yajl::Parser.parse(params[:payload]))
      
      queue = client.new_queue

      payload[:events].each do |event|
        time = Time.zone.at(Time.iso8601(event[:received_at]))
        dyno = event[:program][%r{.*?/(.*)$}, 1]
        
        data = Scrolls::Parser.parse(event[:message])
        
        next unless data[:at] == 'metric'
        
        queue.add data[:measure] => {
          :source       => dyno,
          :value        => data[:val],
          :measure_time => time.to_i,
          :type         => 'gauge',
          :attributes   => { :source_aggregate => true }
        }
      end

      queue.submit

      'ok'
    end
  end
end