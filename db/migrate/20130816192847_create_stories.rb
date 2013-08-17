class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string   "title"
      t.string   "story_type"
      t.string   "pivotal_id"
      t.string   "project"
      t.string   "assigned_to"
      t.string   "created_by"
      t.string   "status"
      t.date     "date"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
