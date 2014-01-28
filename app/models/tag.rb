# == Schema Information
#
# Table name: tags
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class Tag < ActsAsTaggableOn::Tag
  has_many :user_searches

  class << self
    def tag_search(tag, page=1)
      Tag.where("name ILIKE ?", "%#{tag}%").page(page)
    end

    def unique_model_tags(id, model, column)
      table = model.tableize
      joins = "INNER JOIN taggings ON tags.id = taggings.tag_id"
      joins << " INNER JOIN #{table} ON taggings.taggable_id = #{table}.id"
      where = "#{table}.#{column} = #{id} AND taggings.taggable_type = '#{model}'"
      Tag.joins(joins).where(where).group('tags.id,tags.name')
    end
  end
end
