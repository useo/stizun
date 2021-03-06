class CreateAccountingSystem < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :parent_id # for acts_as_tree
      t.integer :user_id
      t.string  :name
      t.integer :type_constant # Assets? Liabilities? etc.
      t.timestamps
    end

    # Text-only historical representation of accounting transactions
    create_table :journal_entries do |t|
      t.string :text
      t.string :credit_account_name
      t.string :debit_account_name
      t.timestamps
    end
    
    # The proper transactions go here
    create_table :account_transactions do |t|
      t.string  :note
      t.integer :credit_account_id
      t.string  :credit_account_type
      t.integer :debit_account_id
      t.string  :debit_account_type
      t.decimal :amount, :scale => 30, :precision => 63
      t.integer :target_object_id
      t.string  :target_object_type
      t.timestamps
    end

    
    
  end

  def self.down
    drop_table :accounts
    drop_table :journal_entries
    drop_table :account_transactions
  end
end
