module SearchModule

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def name_search(query)
      where("name ILIKE ?", "%#{query.downcase}%").order(name: :asc)
    end

    def price_search(args={})
      if args[:min] != nil && args[:max] == nil
        where("unit_price >= ?", args[:min]).order(name: :asc)
      elsif args[:min] == nil && args[:max] 
        where("unit_price <= ?", args[:max]).order(unit_price: :desc)
      else args[:min] != nil && args[:max] != nil
        where("unit_price >= ? AND unit_price <= ?", args[:min], args[:max]).order(unit_price: :asc)
      end
    end
  end
end
