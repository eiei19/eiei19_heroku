namespace :anotoki_yahoo_news do
  task :fetch_from_s3 => :environment do |t|
    s3 = Aws::S3::Client.new(region: "ap-northeast-1")
    res = s3.list_objects(bucket: "anotoki", max_keys: 1000, prefix: Time.now.strftime("news/%Y/%m/%d"))
    res.contents.each do |object|
      s3.get_object(bucket: "anotoki", key: "#{object.key}") do |json|
        data = JSON.parse(json)
        if news = YahooNews.find_by(topic_id: data["id"])
          news.last_posted_at = Time.parse(data["parsed_at"])
        else
          news = YahooNews.new(
            topic_id: data["id"],
            category: data["category"],
            title: data["title"],
            text: data["text"],
            topic_link: data["topic_link"],
            detail_link: data["detail_link"],
            posted_at: Time.parse(data["posted_at"].gsub(/年|月/, "/").gsub(/日\(.*\)/, "").gsub("時", ":").gsub(/分.*/, "")),
            last_posted_at: Time.parse(data["parsed_at"])
          )
        end
        news.save
      end
    end
  end
end