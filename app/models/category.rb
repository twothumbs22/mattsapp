class Category < ActiveRecord::Base
	self.primary_key = "category_id"
	
	has_many :model_product_categories
	has_many :models, :through => :model_product_categories
	has_many :products, :through => :model_product_categories
	
	validates_uniqueness_of :category_id
	validates_presence_of :category_name
	
end
