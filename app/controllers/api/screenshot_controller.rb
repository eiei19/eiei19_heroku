module Api
  class ScreenshotController < ApplicationController
    include Capybara::DSL

    def index
      if Rails.env.production?
        if params[:api_key].blank? || params[:api_key] != ENV["SCREENSHOT_API_KEY"]
          render json: {error: "unauthorized"}
          return
        end
      end
      Capybara.register_driver :poltergeist_shot do |app|
        Capybara::Poltergeist::Driver.new(app, :js_errors => false, :phantomjs_options => ["--ssl-protocol=TLSv1"], :debug => false, timeout: 20)
      end
      Capybara.current_driver = :poltergeist_shot
      visit(params[:url])
      page.driver.resize_window 1000, 1000
      sleep(1)
      page.save_screenshot("tmp/screenshot.png")
      Magick::Image.read('tmp/screenshot.png').first.resize_to_fit(320, 320).write('tmp/320.png')
      Magick::Image.read('tmp/screenshot.png').first.resize_to_fit(640, 640).write('tmp/640.png')
      Magick::Image.read('tmp/screenshot.png').first.resize_to_fit(1280, 1280).write('tmp/1280.png')

      aws_setting = {
        access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
        region: "ap-northeast-1"
      }
      s3_client = Aws::S3::Client.new(aws_setting)
      s3_resource = Aws::S3::Resource.new(aws_setting)
      urls = []
      ["tmp/320.png", "tmp/640.png", "tmp/1280.png"].each do |filepath|
        file_name = "#{SecureRandom.hex(16)}.png"
        s3_client.put_object(
          bucket: "easyscreenshots",
          body: File.open(filepath),
          key: file_name
        )
        urls << s3_resource.bucket("easyscreenshots").object(file_name).public_url.gsub("easyscreenshots.s3-ap-northeast-1.amazonaws.com", "d1zmt8esqugh3r.cloudfront.net")
      end
      render json: urls
    end
  end
end