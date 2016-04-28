module Api
  class ScreenshotController < ApplicationController
    def index
      if Rails.env.production?
        if params[:api_key].blank? || params[:api_key] != ENV["SCREENSHOT_API_KEY"]
          render json: {error: "unauthorized"}
          return
        end
      end
      if params[:url].blank? || !(params[:url] =~ URI::regexp)
        render json: {error: "invalid url"}
        return
      end
      width = params[:width] || 1200
      height = params[:height] || 900
      setting = {
        access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
        region: "ap-northeast-1"
      }
      s3 = Aws::S3::Client.new(setting)
      ws = Webshot::Screenshot.instance
      shot = ws.capture params[:url], "tmp/tmp.png", width: width, height: height, quality: 100
      file_name = "#{SecureRandom.hex(16)}.png"
      s3.put_object(
        bucket: "easyscreenshots",
        body: shot.to_blob,
        key: file_name
      )
      s3 = Aws::S3::Resource.new(setting)
      obj = s3.bucket("easyscreenshots").object(file_name)
      render json: {url: obj.public_url}
    end
  end
end