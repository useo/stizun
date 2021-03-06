
# prod[] is hash generated from a Cucumber table, e.g.
# table.hashes.each do |prod|; foo; end
def create_product(prod)

    purchase_price = BigDecimal.new("0.0")
    purchase_price = BigDecimal.new(prod['purchase_price'].to_s) unless prod['purchase_price'].nil?
    margin_percentage = BigDecimal.new("0.0")
    margin_percentage = prod['margin_percentage'].to_f unless prod['margin_percentage'].nil?
    sales_price = nil
    sales_price = BigDecimal.new(prod['sales_price']) unless prod['sales_price'].nil?
    direct_shipping = false
    direct_shipping = true if prod['direct_shipping'] == "true"
    weight = 0
    weight = prod['weight'].to_f unless prod['weight'].nil?
    manufacturer_product_code = prod['manufacturer_product_code']

    tax_percentage = prod['tax_percentage'] || 8.0
    tax_class = TaxClass.where(:percentage => tax_percentage).first unless tax_percentage.nil?
    if tax_class.nil?
      tax_class = TaxClass.create(:percentage => 8.0, :name => "8.0")
    end

    prod['description'].blank? ? description = "No description" : description = prod['description']
    
    supplier = Supplier.find_by_name(prod['supplier'])
    product = Product.create(:name => prod['name'],
                             :description => description,
                             :weight => weight,
                             :sales_price => sales_price,
                             :supplier => supplier,
                             :tax_class => tax_class,
                             :purchase_price => purchase_price,
                             :margin_percentage => margin_percentage,
                             :manufacturer_product_code => manufacturer_product_code,
                             :direct_shipping => direct_shipping)
  if prod['category']
    category = Category.where(:name => prod['category']).first
    category = Category.create(:name => prod['category']) if category.nil?
    product.categories << category
    product.save
  end

  # Ugly, but at least it makes test authors know what went wrong
  if product.errors.empty?
    return product
  else
    puts "Errors creating product: #{product.errors.full_messages}"
    return false
  end
end