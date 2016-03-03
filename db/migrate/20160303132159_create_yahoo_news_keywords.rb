class CreateYahooNewsKeywords < ActiveRecord::Migration
  def change
    create_table :yahoo_news_keywords do |t|
      t.date :week_start_date
      t.string :word
      t.integer :count
      t.datetime :updated_at
    end
    add_index :yahoo_news_keywords, :week_start_date
    add_index :yahoo_news_keywords, [:week_start_date, :word]
  end
end
