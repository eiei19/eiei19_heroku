SitemapGenerator::Interpreter.send :include, Anotoki::ApplicationHelper
SitemapGenerator::Sitemap.default_host = "https://eiei19.herokuapp.com/"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'anotoki_sitemaps/'
SitemapGenerator::Sitemap.sitemaps_host = "https://s3-ap-northeast-1.amazonaws.com/#{Rails.application.config.anotoki_s3_bucket}"
SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new
SitemapGenerator::Sitemap.create do
  since_date = YahooNews.all.first.posted_at.to_date
  until_date = YahooNews.all.last.posted_at.to_date
  (since_date..until_date).each do |date|
    add anotoki_path(date), priority: 0.8
  end
  YahooNewsKeyword.find_each do |keyword|
    add  URI.escape(anotoki_path(keyword.week_start_date, keyword.word)), priority: 0.8
  end
end
