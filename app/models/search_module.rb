module SearchModule

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def name_search(query)
      where("lower(name) ILIKE ?", "%#{query.downcase}%").order(name: :asc)
    end

    def price_search(args={})
      if args[:min] != nil && args[:max] == nil
        where("unit_price >= ?", args[:min]).order(unit_price: :asc)
      elsif args[:min] == nil && args[:max] != nil
        where("unit_price <= ?", args[:max]).order(unit_price: :asc)
      else
        where("unit_price >= ? AND unit_price <= ?", args[:min], args[:max]).order(unit_price: :asc)
      end
    end
  end
end
