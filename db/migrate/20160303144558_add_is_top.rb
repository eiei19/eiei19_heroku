class AddIsTop < ActiveRecord::Migration
  def change
    add_column :yahoo_news, :is_top, :boolean, default: false, after: :category
  end
end
