class ModelSummary < ActiveRecord::Base
	has_many :models,
			 :order => "year ASC"

end
