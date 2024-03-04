require "google/cloud/vision"
require "google/cloud/translate/v2"

if Rails.env.development?
  Google::Cloud::Vision.configure do |config|
    config.credentials = JSON.parse(ENV.fetch('TRANSLATE_CREDENTIALS'))
  end
else
  Google::Cloud::Vision.configure do |config|
    config.credentials = JSON.parse(ENV.fetch('VISION_CREDENTIALS'))
  end
end
