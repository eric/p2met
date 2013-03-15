require 'yajl'
require 'librato/metrics'
require 'sinatra'
require 'scrolls'

module P2met
  class App < Sinatra::Base
    get '/' do
      "200\n"
    end

    post '/submit' do
      librato_user  = params[:librato_user]    || ENV['LIBRATO_USER']
      librato_token = params[:librato_token]   || ENV['LIBRATO_TOKEN']
      librato_prefix = params[:librato_prefix] || ENV['LIBRATO_PREFIX']

      client = Librato::Metrics::Client.new
      client.authenticate(librato_user.to_s.strip, librato_token.to_s.strip)

      payload = Yajl::Parser.parse(params[:payload])

      queue = client.new_queue

      payload['events'].each do |event|
        time = Time.iso8601(event['received_at'])
        dyno = event['program'][%r{.*?/(.*)$}, 1]

        data = Scrolls::Parser.parse(event['message'])

        next unless data[:at] == 'metric'

        if librato_prefix
          name = "#{librato_prefix}.#{data[:measure]}"
        else
          name = data[:measure]
        end

        queue.add name => {
          :source       => dyno,
          :value        => data[:val],
          :measure_time => time.to_i,
          :type         => 'gauge',
          :attributes   => {
            :source_aggregate => true,
            :display_min => 0,
            :display_units_short => data[:units],
            :display_units_long => data[:units]
          }
        }
      end

      queue.submit

      'ok'
    end
  end
end
