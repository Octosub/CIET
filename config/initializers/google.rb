require "google/cloud/vision"
require "google/cloud/translate/v2"

Google::Cloud::Vision.configure do |config|
  config.credentials = JSON.parse(ENV.fetch('VISION_CREDENTIALS'))
end
