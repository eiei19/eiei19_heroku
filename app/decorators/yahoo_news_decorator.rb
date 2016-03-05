class YahooNewsDecorator < Draper::Decorator
  delegate_all
  def formatted_duration
    if posted_duration_minutes < 60
      return "#{posted_duration_minutes}分"
    else
      return "#{posted_duration_minutes/60}時間"
    end
  end
end
