class CreateModelSummaries < ActiveRecord::Migration
  def self.up
    create_table :model_summaries do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :model_summaries
  end
end
