class RemoveText < ActiveRecord::Migration
  def change
    remove_column :yahoo_news, :text
  end
end
