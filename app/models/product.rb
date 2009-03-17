class Product < ActiveRecord::Base	
	self.primary_key = "product_id"
	
	has_many :model_product_categories
	has_many :categories, :through => :model_product_categories
	has_many :models, :through => :model_product_categories
	
	validates_uniqueness_of :product_id
	validates_presence_of :product_number
	validates_presence_of :product_desc
	
	
	
end
