class Model < ActiveRecord::Base
	self.primary_key = "model_id"
	
	belongs_to  :model_summary
	has_many :model_product_categories
	has_many :products, :through => :model_product_categories
	has_many :categories, :through => :model_product_categories
	
	validates_uniqueness_of :model_id
	validates_presence_of :make
	validates_presence_of :year
	validates_presence_of :cc
	validates_presence_of :description

	def self.get_makes
		find_by_sql("SELECT DISTINCT make FROM models")
	end

	def self.get_model(make)
        find_by_sql(["SELECT description, model, cc FROM models WHERE make = ? GROUP BY description ORDER BY cc", make])
	end

	def self.get_model2(make, year)
        find_by_sql(["SELECT description, model, cc FROM models WHERE make = ? AND year = ? GROUP BY description ORDER BY cc", make, 		year])
	end

	def self.get_year(make)
        find_by_sql(["SELECT DISTINCT year FROM models WHERE make = ? ORDER BY year ASC", make])
	end

	def self.get_year2(make, model)
        find_by_sql(["SELECT DISTINCT year FROM models WHERE make = ? AND description = ?", make, model])
	end

	def self.get_atv(make, model, year)
		find(:first, :conditions => ["make = ? and description = ? and year = ?", make, model, year])
	end
	
	def self.get_model_years(make)
        find_by_sql(["SELECT * FROM models WHERE make = ? ORDER BY cc, description, year", make])
	end
	
	def self.get_categories()
		find_by_sql("SELECT * FROM categories WHERE parent_id >= 1 ORDER BY category_id")
	end
	
	def self.get_models_by_make(make)
		find(:all, :conditions => ["make = ?", make], :order => "cc, description, year")
	end
	
	def self.get_distinct_models
		find_by_sql("SELECT description, cc, make, model FROM `mcdonline_development`.`models` group by description
				order by make, cc, description")
	end
  			
	def self.get_years_by_mod_sum(id, prod)
	  find( :all, :select => "DISTINCT year", 
	  		:conditions => ["models.model_summary_id = ? AND model_product_categories.product_id = ?", id, prod], 
	  		:order => "year",
	  		:joins => "right join model_product_categories on models.model_id = model_product_categories.model_id")
	end


end
