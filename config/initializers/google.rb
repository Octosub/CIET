require "google/cloud/vision"
require "google/cloud/translate/v2"

if Rails.environment.development?
  Google::Cloud::Vision.configure do |config|
    config.credentials = JSON.parse(ENV.fetch('VISION_CREDENTIALS'))
  end
else
  Google::Cloud::Vision.configure do |config|
    config.credentials = JSON.parse(ENV.fetch('GOOGLE_CREDENTIALS'))
  end
end
