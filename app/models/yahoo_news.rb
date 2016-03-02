class YahooNews < ActiveRecord::Base
  before_save :calc_posted_duration
  def calc_posted_duration
    self.posted_duration_minutes = ((last_posted_at - posted_at)/60).round(0)
  end
end