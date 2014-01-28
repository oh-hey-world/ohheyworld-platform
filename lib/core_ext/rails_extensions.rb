module Kernel
 public
    def this_method_name
      caller[0] =~ /`([^']*)'/ and $1
    end
end

class String
  def sentance_case
    self.split(/\s+/).each{ |word| word.capitalize! }.join(' ') unless self.blank?
  end
  
  def strip_punctuation_alpha
    self.gsub(/[(,?!\'":.$)]/, '').gsub(/[(a-z)]/, '') unless self.blank?
  end
  
  class << self
    def strip_punctuation_alpha(some_string)
      some_string.gsub(/[(,?!\'":.$)]/, '').gsub(/[(a-z)]/, '') unless some_string.blank?
    end
  end
end

class Array
  def to_hash_keys(&block)
    Hash[*self.collect { |v|
      [v, block.call(v)]
    }.flatten]
  end

  def to_hash_values(&block)
    Hash[*self.collect { |v|
      [block.call(v), v]
    }.flatten]
  end
end

class BaseTask
  def self.perform(*args)
    ActiveRecord::Base.verify_active_connections! 
  end
end

class ActiveRecord::Base
  def self.none
    where(arel_table[:id].eq(nil).and(arel_table[:id].not_eq(nil)))
  end
end