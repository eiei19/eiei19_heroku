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
    return Hash[keywords.sort.reverse]
  end

  private
    def self.get_threshold date
      today = Date.today
      if date < (today - today.wday)
        ## 過去の週
        7
      else
        if 4 <= today.wday
          ## 木曜以降
          7
        elsif 2 <= today.wday
          ## 火曜以降
          4
        else
          ## 月曜まで
          2
        end
      end
    end
end