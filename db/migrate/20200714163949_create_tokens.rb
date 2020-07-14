class CreateTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :tokens do |t|
      t.string :expires_at
      t.string :token
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
