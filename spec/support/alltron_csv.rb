
class AlltronTestHelper

  def self.import_from_file(filename)
    require 'lib/alltron_util'
    au = AlltronUtil.new
    au.import_supply_items(Rails.root + filename)
  end
  
end