require "google/cloud/vision"

Google::Cloud::Vision.configure do |config|
  config.credentials = JSON.parse(ENV.fetch('VISION_CREDENTIALS'))
end
