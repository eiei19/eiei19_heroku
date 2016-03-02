class CreateYahooTopics < ActiveRecord::Migration
  def change
    create_table :yahoo_news do |t|
      t.string :topic_id
      t.string :category
      t.string :title
      t.text :text
      t.string :topic_link
      t.string :detail_link
      t.datetime :posted_at
      t.datetime :last_posted_at
      t.integer :posted_duration_minutes
    end
    add_index :yahoo_news, :topic_id
    add_index :yahoo_news, :posted_at
  end
end
