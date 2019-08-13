require('pry-byebug')
require_relative('./model/property')


Property.delete_all


property1 = Property.new({
  'address' => 'London Road',
  'value' =>'850 £',
  'number_of_bedrooms' => '2',
  'year_built' => '2004'
  })

property2 = Property.new({
  'address' => 'Edinburgh Road',
  'value' =>'750 £',
  'number_of_bedrooms' => '1',
  'year_built' => '2010'
    })

property1.save()
property2.save()

property1.value = "800 £"
property1.update

# property1.delete
# Property.find_by_id(10)

binding.pry
nil
