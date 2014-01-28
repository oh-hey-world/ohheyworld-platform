class AddAttachmentBrandToCommunities < ActiveRecord::Migration
  def self.up
    change_table :communities do |t|
      t.attachment :brand
    end
  end

  def self.down
    drop_attached_file :communities, :brand
  end
end
