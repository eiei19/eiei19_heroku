module Api
  class ScreenshotController < ApplicationController
    def index
      s3 = Aws::S3::Client.new(
        access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
        region: "ap-northeast-1"
      )


      ws = Webshot::Screenshot.instance
      shot = ws.capture "http://www.google.com/", "tmp/google.png", width: 1200, height: 900, quality: 90

      s3.put_object(
        bucket: "easyscreenshots",
        body: shot.to_blob,
        key: "test.png"
      )

      render json: []
    end
  end
end