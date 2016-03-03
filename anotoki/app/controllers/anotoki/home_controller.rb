require_dependency "anotoki/application_controller"

module Anotoki
  class HomeController < ApplicationController
    def index
      target_date = 4.weeks.ago
      week_start_date = target_date - target_date.wday
      @keywords = YahooNewsKeyword.where(
        "? <= week_start_date AND week_start_date <= ?",
        week_start_date, week_start_date+28.days
      ).group_by do |keyword|
        keyword.week_start_date
      end
    end
  end
end