Seory.seo_content 'anotoki' do
  anotoki_desc = "アノトキノヤフーニュースはYahooニュースのアーカイブサービスです。過去にYahooニュースのTOPに掲載された記事を振り返ることができます。"
  anotoki_keyword = %w(Yahoo ニュース 過去 昔 アーカイブ)

  match (->(controller) {
    (
      controller.class.name.split("::").first == "Anotoki" &&
      controller.controller_name == "news" &&
      controller.action_name == "date"
    )
  }) do
    assign_reader :title_h1
    title {"#{title_h1} | アノトキノヤフーニュース"}
    meta_description anotoki_desc
    meta_keywords anotoki_keyword
  end

  match (->(controller) {
    (
      controller.class.name.split("::").first == "Anotoki" &&
      controller.controller_name == "news" &&
      controller.action_name == "keyword"
    )
  }) do
    assign_reader :title_h1
    title {"#{title_h1} | アノトキノヤフーニュース"}
    meta_description anotoki_desc
    meta_keywords anotoki_keyword
  end

  match (->(controller) {
    (
      controller.class.name.split("::").first == "Anotoki"
    )
  }) do
    title "アノトキノヤフーニュース"
    meta_description anotoki_desc
    meta_keywords anotoki_keyword
  end
end