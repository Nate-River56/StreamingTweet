class MigrateTweet < ActiveRecord::Migration
  def self.up
    create_timestamp = 'DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP'
    create_table :tweets do |t|
      t.string :keywords, null: false
      t.string :user_id, null: false
      t.string :screen_name, null: false
      t.string :name, null: false
      t.text   :text, null: false
      t.string :posted_at, null: false
      t.column :created_at, create_timestamp
    end
  end

  def self.down
    drop_table :tweets
  end
end
