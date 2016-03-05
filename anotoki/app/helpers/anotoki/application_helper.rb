module Anotoki
  module ApplicationHelper
    include Seory::RailsHelper
    def anotoki_path date, keyword=nil
      yyyy, mm, dd = date.strftime("%Y/%m/%d").split("/")
      if keyword
        "/anotoki/#{yyyy}/#{mm}/#{dd}/#{keyword}"
      else
        "/anotoki/#{yyyy}/#{mm}/#{dd}"
      end
    end
  end
end
