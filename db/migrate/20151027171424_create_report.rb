class CreateReport < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.attachment :generated_report
    end
  end
end
