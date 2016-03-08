CarrierWave.configure do |config|
  def cache_dir
    "tmp/uploads"
  end
  config.storage :fog
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV["AWS_ACCESS_KEY_ID"],
    :aws_secret_access_key  => ENV["AWS_SECRET_ACCESS_KEY"],
    :region                 => "ap-northeast-1",
    :path_style             => true,
  }
  config.fog_directory = Rails.application.config.anotoki_s3_bucket
end
