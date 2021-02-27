class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    enable_extension :citext

    create_table :contacts do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.citext :email, null: false, index: { unique: true }
      t.string :phone_number, null: false

      t.timestamps
    end
  end
end
