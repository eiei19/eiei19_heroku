class YahooNewsKeyword < ActiveRecord::Base
  def self.get_keywords target_date=Date.today
    target_date = 4.weeks.ago
    week_start_date = target_date - target_date.wday
    keywords = YahooNewsKeyword.where(
      ## 指定日時の前後4週間を取得する
      "? <= week_start_date AND week_start_date <= ?",
      week_start_date, (week_start_date+4.weeks)
    ).order("count desc")
    .select do |keyword|
      ## 時期によってしきい値を変える
      threshold = get_threshold(keyword.week_start_date)
      threshold <= keyword.count
    end
    .group_by do |keyword|
      ## 週ごとにグルーピング
      keyword.week_start_date
    end
    return keywords
  end

  private
    def self.get_threshold date
      today = Date.today
      if date < (today - today.wday)
        ## 過去の週は3s
        3
      else
        if 2 <= today.wday
          ## 火曜以降は3
          3
        else
          ## 月曜までは2
          2
        end
      end
    end
end