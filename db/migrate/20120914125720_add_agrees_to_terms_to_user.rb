class AddAgreesToTermsToUser < ActiveRecord::Migration
  def change
    add_column :users, :agrees_to_terms, :boolean

  end
end
