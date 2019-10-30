class CreateZookeepers < ActiveRecord::Migration
  def change
    create_table :zookeepers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
    end
  end
end