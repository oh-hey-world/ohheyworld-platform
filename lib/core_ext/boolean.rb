class Boolean
  def self.parse(value)
    %w(true t 1 y).include?(value.to_s.downcase.strip)
  end
end