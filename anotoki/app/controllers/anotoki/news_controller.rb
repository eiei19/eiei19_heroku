require_dependency "anotoki/application_controller"

module Anotoki
  class NewsController < ApplicationController
    def index
      @keywords = YahooNewsKeyword::get_keywords
    end

    def date
      target_date = Date.parse(params[:yyyy]+params[:mm]+params[:dd])
      @title_h1 = target_date.strftime("%Y年%-m月%-d日のニュース")
      @grouped_news = YahooNews.where(
        "? <= posted_at AND posted_at <= ?",
        target_date.beginning_of_day, target_date.end_of_day,
      ).order("posted_duration_minutes asc").try(:decorate).group_by do |news|
        news.category
      end
    end

    def keyword
      target_date = Date.parse(params[:yyyy]+params[:mm]+params[:dd])
      week_start_date = target_date - target_date.wday
      @title_h1 = week_start_date.strftime("%Y年%-m月%-d日週の「#{params[:keyword]}」を含むニュース")
      @news = YahooNews.where(
        "? <= posted_at AND posted_at <= ? AND title like '%#{params[:keyword]}%'",
        week_start_date.beginning_of_day, (week_start_date+6).end_of_day,
      ).order("posted_duration_minutes asc").try(:decorate)
    end

  end
end