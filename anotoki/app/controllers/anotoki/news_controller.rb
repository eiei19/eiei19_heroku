require_dependency "anotoki/application_controller"

module Anotoki
  class NewsController < ApplicationController
    def index
      target_date = 4.weeks.ago
      week_start_date = target_date - target_date.wday
      @keywords = YahooNewsKeyword.where(
        "? <= week_start_date AND week_start_date <= ?",
        week_start_date, week_start_date+28.days
      ).order("count desc").limit(15)
      .group_by do |keyword|
        keyword.week_start_date
      end
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