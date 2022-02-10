module SearchModule

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def name_search(query)
      where("lower(name) ILIKE ?", "%#{query.downcase}%").order(name: :asc)
    end
  end
end
