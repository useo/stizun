Given /^there is a configuration item named "([^\"]*)" with value "([^\"]*)"$/ do |name, value|
  ci = ConfigurationItem.new(:description => name,:name => name, :key => name, :value => value)
  ci.save
end

When /^I invoice the order$/ do
  # TODO: This depends on these accounts actually being there. Create the accounts
  # if they aren't.
  ConfigurationItem.create(:name => "accounts_receivable_id", :key => "accounts_receivable_id", :value => Account.find_by_name("Accounts Receivable"))
  
  ConfigurationItem.create(:name => "sales_income_account_id", :key => "sales_income_account_id", :value => Account.find_by_name("Product Sales"))
  
  @invoice = Invoice.create_from_order(@order)
end

When /^the invoice is paid$/ do
  accts_receivable = Account.find_by_name("Accounts Receivable")
  ci = ConfigurationItem.create(:key => "accounts_receivable_id",
                                :value => accts_receivable.id)
  @invoice.record_payment_transaction
end

Then /^the invoice total is (\d+\.\d+)$/ do  |num|

#    puts "total price is #{@invoice.rounded_price}"
#    puts @invoice.inspect
#    @invoice.lines.each do |line|
#      puts "rounded [#{line.quantity}]x #{line.text} [#{line.single_rounded_price}] = [#{line.rounded_price}], tax #{line.taxes}"
#      puts "gross line [#{line.gross_price}]"
#      puts line.inspect.to_s
#    end
# 
#    puts "--- ACCOUNTS ---"
#    Account.all.each do |ac|
#      puts ac.name.to_s
#    end
#    puts "--- END ACCTS ---"
   
   @invoice.price.should == BigDecimal.new(num.to_f.to_s)
end

Then /^the balance of the sales income account is (\d+\.\d+)$/ do |balance|
  Account.find(ConfigurationItem.get('sales_income_account_id').value).balance.should == BigDecimal.new(balance.to_s)
end
