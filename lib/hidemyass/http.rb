module Hidemyass
  module HTTP
    def HTTP.start(address, *arg, &block)
      Hidemyass.log 'Connecting to ' + address + ' through:'
      response = nil
  
      if Hidemyass.options[:local]
        begin
          Hidemyass.log 'localhost...'
          response = Net::HTTP.start(address, *arg, &block)
          if response.class.ancestors.include?(Net::HTTPSuccess)
            return response
          end
        rescue *HTTP_ERRORS => error
          Hidemyass.log error
        end
      end
      
      Hidemyass.proxies.each do |proxy|
        begin
          Hidemyass.log proxy[:host] + ':' + proxy[:port]
          response = Net::HTTP::Proxy(proxy[:host], proxy[:port]).start(address, *arg, &block)
          Hidemyass.log response.class.to_s
          if response.class.ancestors.include?(Net::HTTPSuccess)
            return response
          end
        rescue *HTTP_ERRORS => error
          Hidemyass.log error
        end
      end

      response
    end
  end
end