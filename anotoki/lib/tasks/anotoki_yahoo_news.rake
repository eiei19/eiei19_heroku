require 'open-uri'
namespace :anotoki_yahoo_news do
  task :fetch_from_s3 => :environment do |t|
    s3 = Aws::S3::Client.new(region: "ap-northeast-1")
    res = s3.list_objects(bucket: "anotoki", max_keys: 1000, prefix: Time.now.strftime("news/%Y/%m/%d"))
    res.contents.each do |object|
      s3.get_object(bucket: "anotoki", key: "#{object.key}") do |json|
        data = JSON.parse(json)
        if news = YahooNews.find_by(topic_id: data["id"])
          news.last_posted_at = Time.parse(data["parsed_at"])
          news.is_top = true if data["is_top"]
        else
          news = YahooNews.new(
            topic_id: data["id"],
            category: data["category"],
            is_top: data["is_top"],
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

  task :generate_keywords, ["date"] => :environment do |t, args|
    reject_words = %w(女性 男性 逮捕 結婚 死亡 捜査 批判 否定 決議 採択 終了 停止 殺害 処分 投手 選手 アナ 日本)
    if args[:date]
      target_date = Date.parse(args[:date])
    else
      target_date = Date.today
    end
    week_start_date = target_date - target_date.wday
    keywords = {}
    YahooNews.where("? <= posted_at AND posted_at <= ?", week_start_date.beginning_of_day, (week_start_date+6).end_of_day).find_in_batches(batch_size: 15) do |news_list|
      sentence = news_list.map{|news|news.title}.join(",")
      query = "http://jlp.yahooapis.jp/MAService/V1/parse?appid=#{ENV["YAHOO_APP_ID"]}&results=uniq&uniq_filter=9&sentence=#{sentence}"
      res = Hash.from_xml(open(URI.encode(query)).read)
      res["ResultSet"]["uniq_result"]["word_list"]["word"].each do |w|
        word = w["surface"].gsub(/\d/, "")
        next if word.blank?
        count = w["count"].to_i
        keywords[word] = 0 unless keywords[word]
        keywords[word] += count
      end
    end
    keywords = keywords.reject{|keyword, count| count < 2 || keyword.length < 2 || reject_words.include?(keyword)}
    keywords.each do |word, count|
      if keyword = YahooNewsKeyword.find_by(week_start_date: week_start_date, word: word)
        keyword.count = count
      else
        keyword = YahooNewsKeyword.new(week_start_date: week_start_date, word: word, count: count)
      end
      keyword.save
    end
  end

end