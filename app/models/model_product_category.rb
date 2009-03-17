class ModelProductCategory < ActiveRecord::Base
	belongs_to :product
	belongs_to :category
	belongs_to :model
	
	validates_presence_of :model_id
	validates_presence_of :product_id
	validates_presence_of :category_id
	
	validates_associated :model,
						 :message => "model is invalid"
	validates_associated :product,
						 :message => "product is invalid"
	validates_associated :category,
						 :message => "category is invalid"
						 
	
						 
	def self.get_apps(atv)
	  find( :all, :conditions => ["model_id = ?", atv], :order => "ca.parent_id, category_id asc", 
	  		:joins => "left join categories as ca on model_product_categories.category_id = ca.category_id")
	end
	
	def self.get_recent_apps()
	  find( :all, :order => "id DESC", :limit => 200)	
	end
	
	def self.unique_app(mod, cat, prod)
	  find_by_sql(["SELECT * FROM model_product_categories WHERE model_id = ? AND category_id = ? AND product_id = ?", mod, cat, prod])
	end
	
	def self.get_apps_by_make_category(make, category)
	  find( :all, :conditions => ["models.make = ? AND category_id = ?", make, category], :order => "models.model_summary_id, models.cc, models.description, product_id, models.year", :joins => "left join models on model_product_categories.model_id = models.model_id")
	end
	
	def self.get_product_by_mod_sum(id, cat)
	  find( :all, :select => "DISTINCT product_id", 
	  		:conditions => ["models.model_summary_id = ? AND category_id = ?", id, cat], 
	  		:order => "product_id",
	  		:joins => "left join models on model_product_categories.model_id = models.model_id")
	end
	
	private
	
end
