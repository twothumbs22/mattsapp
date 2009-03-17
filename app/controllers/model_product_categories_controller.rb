class ModelProductCategoriesController < ApplicationController
  auto_complete_for :product, :product_number,
  					:limit => 20, :order => 'product_number ASC'
  
  def index
	list
	render :action => 'list'
  end
  
  def list   
  	@atv_make2 = ""
  	@atv_makes = Model.get_makes    
  end

  def model_select2 
    $atv_make = params[:atv_make]    
    @atv_models = Model.get_model(params[:atv_make])   
    @atv_years = Model.get_year(params[:atv_make])  
    render :layout => false 
  end
  
  def model_select3
    if (params[:atv_model])
      $atv_model = params[:atv_model]
    else
      $atv_year = params[:atv_year]
    end  
  
    if (params[:atv_model])
      @atv_years = Model.get_year2($atv_make, $atv_model)
    end    
  
    if (params[:atv_year])
      @atv_models = Model.get_model2($atv_make, $atv_year)
    end        
    render :layout => false
  end

  def display_atv
	if(params[:atv_model] and params[:atv_year] and params[:atv_make])
	  @atv_final = Model.get_atv(params[:atv_make], params[:atv_model], params[:atv_year])
	  @atv_apps = ModelProductCategory.get_apps(@atv_final.id)
	  @atv_make = params[:atv_make]
	  @atv_model = params[:atv_model]
	  @atv_year = params[:atv_year]
	end	
	render :layout => false
  end

  def add_app  	
  	@atv_make2 = ""
  	@atv_makes = Model.get_makes    
    @atv_categories = Model.get_categories()  
    @recent_mpc = ModelProductCategory.get_recent_apps()
  end
  
  def show_models
  	$atv_make = params[:atv_make]
    @atv_models = Model.get_model_years(params[:atv_make]) 
  	
    render :layout => false
  end
  
  def update_applications
  	begin
  	  @update_make = params[:atv_make]
  	  @update_category = Category.find(params[:atv_category])
 	  @product = Product.find(:first, :conditions => ["products.product_number = ?", params[:product][:product_number]])	
 	  @note = params[:atv_note]
      if params[:atv_model]
  	    @update_mpc = params[:atv_model]
  	    if @product
  	      for mpc in @update_mpc 
  	      	@model = Model.find(mpc)
  		    @mpc_to_save = ModelProductCategory.new  		
  		    @mpc_to_save.model_id = mpc
  		    @mpc_to_save.product_id = @product.id
  		    @mpc_to_save.category_id = @update_category.id
  		    @mpc_to_save.note = @note  	
  		    if @mpc_to_save.valid?
  		    	if !ModelProductCategory.first(:conditions => ["model_product_categories.model_id = ? and 															model_product_categories.category_id = ? and model_product_categories.product_id = ?", 															@mpc_to_save.model_id, @mpc_to_save.category_id, @mpc_to_save.product_id ]).nil?
  		    		
  		    		logger.error("Application for #{@model.year} #{@model.model} - #{@model.description}, | 															#{@update_category.category_name} | #{@product.product_number} Already Exists.")	
  		    		if flash.now[:notice]
  		    		flash.now[:notice] << "<br>Application for #{@model.year} #{@model.model} - #{@model.description}, | 												#{@update_category.category_name} | #{@product.product_number} Already Exists."
  		    		else
  		    		flash.now[:notice] = "Application for #{@model.year} #{@model.model} - #{@model.description}, | 													#{@update_category.category_name} | #{@product.product_number} Already Exists."
  		    		end
  		    			
  		    	else
	  		  	  @mpc_to_save.save
  		  		end
  		    else
  		  	
	  	    end    		  	
  	      end  	
  	    else
  	      logger.error("Invalid product #{params[:product][:product_number]}")
	      flash.now[:notice] = flash[:notice] + "Invalid product '#{params[:product][:product_number]}'"
        end  
      else   	  
	    logger.error("Must select Model(s) to apply Part/Category to.")
	    flash.now[:notice] = "Must select Model(s) to apply Part/Category to."	 
	  end  
	rescue
      logger.error("Invalid SQL search.")
	  flash.now[:notice] = "Invalid SQL search."  		    		
	end  	 
	
    @recent_mpc = ModelProductCategory.get_recent_apps()	  
  end
  
  def app_editor  	
  	@atv_make2 = ""
  	@atv_makes = Model.get_makes    
    @atv_categories = Model.get_categories()  
    @recent_mpc = ModelProductCategory.get_recent_apps()
  end
  
  def app_edit_list
  	@applications = ModelProductCategory.get_apps_by_make_category(params[:atv_make], params[:atv_category])
  	@model_summary_by_make = ModelSummary.find(:all, :conditions => ["make = ?", params[:atv_make]])   	
  	@atv_category = params[:atv_category]
  	
  	@newpart = "_newpart"
  	
  	@mod_sum_hash = Hash.new  	
  	for mod_sum in @model_summary_by_make
  		@products = ModelProductCategory.get_product_by_mod_sum(mod_sum.id, params[:atv_category])
  		if @products.length > 0
  		@mod_sum_hash[mod_sum.id] = Hash.new
  		
  		for prod in @products
  			year_array = Array.new
  			@mod_sum_hash[mod_sum.id][prod.product.product_number]= Hash.new
  			@years = Model.get_years_by_mod_sum(mod_sum.id, prod.product_id)
  			for year in @years
  				year_array << year.year
  			end  			
  			@mod_sum_hash[mod_sum.id][prod.product.product_number] = year_array
  		end 			   	
  		end	
  	end
 	
  end

  def remove_mpc  	
  	@product = Product.find( :first, :conditions => ['product_number = ?', params[:atv_product]] )
  	@atv_model = params[:atv_model].split("_")
  	@model_id = Model.find( :first, :conditions => ['model_summary_id = ? AND year = ?', @atv_model[0], @atv_model[1]])
   	
  	@mpc_to_remove = ModelProductCategory.new  		 	
  	
  	if @mpc_to_remove = ModelProductCategory.find( :first, 
  		:conditions => ['model_id = ? AND product_id = ? AND category_id = ?', 
  		@model_id.model_id, @product.product_id, params[:atv_category]])
  		
  	  ModelProductCategory.delete(@mpc_to_remove.id)
  	end
  	
  	render :update do |page|
  	  page.insert_html :top, 'results', :partial => 'rem_results'
  	  page.replace_html params[:atv_model].delete('_')+params[:atv_product], :partial => 'mpc_removed'  	  
  	end
  	  	
  end

  def add_mpc
  	@product = Product.find( :first, :conditions => ['product_number = ?', params[:atv_product]] )
  	@atv_model = params[:atv_model].split("_")
  	@model_id = Model.find( :first, :conditions => ['model_summary_id = ? AND year = ?', @atv_model[0], @atv_model[1]])
	  
  	
  	@mpc_to_save = ModelProductCategory.new  		
  	@mpc_to_save.model_id = @model_id.model_id
  	@mpc_to_save.product_id = @product.product_id
  	@mpc_to_save.category_id = params[:atv_category]
  	@mpc_to_save.note = params[:atv_note]	  	
  	if @mpc_to_save.valid?
  		if !ModelProductCategory.first(:conditions => ["model_product_categories.model_id = ? and 														model_product_categories.category_id = ? and model_product_categories.product_id = ?", 														@mpc_to_save.model_id, @mpc_to_save.category_id, @mpc_to_save.product_id ]).nil?
  		    		
  		    logger.error("Application for #{@model.year} #{@model.model} - #{@model.description}, | 															#{@update_category.category_name} | #{@product.product_number} Already Exists.")	  
  		    flash.now[:notice] = "Application for #{@model.year} #{@model.model} - #{@model.description}, | 													#{@update_category.category_name} | #{@product.product_number} Already Exists."
  		    render :update do |page|
  	    	page.insert_html :top, 'results', :partial => 'add_results'
  	  		end   
  		else
	  	  @mpc_to_save.save
  		end
  	end
  	
  	render :update do |page|
  	  page.insert_html :top, 'results', :partial => 'add_results'
  	  page.replace_html params[:atv_model].delete('_')+params[:atv_product], :partial => 'mpc_added'  	  
  	end
  end

  def add_mpc_row
  	@product = Product.find( :first, :conditions => ['product_number = ?', params[:atv_product]] )
  	@atv_model = params[:atv_model].split("_")
  	@model_id = Model.find( :first, :conditions => ['model_summary_id = ? AND year = ?', @atv_model[0], @atv_model[1]])	  
  	@newpart = "_newpart"
  	if @product.nil?
  	  logger.error("Missing or Invalid Product Number #{params[:atv_product]}")	  
  		    flash.now[:notice] = "Missing or Invalid Product Number #{params[:atv_product]}"
  		    
  	  render :update do |page|
  	    page.insert_html :top, 'results', :partial => 'add_results'
  	  end   	
    else
  	  @mpc_to_save = ModelProductCategory.new
  	  @mpc_to_save.model_id = @model_id.model_id
  	  @mpc_to_save.product_id = @product.product_id
  	  @mpc_to_save.category_id = params[:atv_category]
  	  @mpc_to_save.note = params[:atv_note]
  	  if @mpc_to_save.valid? 
  		if !ModelProductCategory.first(:conditions => ["model_product_categories.model_id = ? and 														model_product_categories.category_id = ? and model_product_categories.product_id = ?", 														@mpc_to_save.model_id, @mpc_to_save.category_id, @mpc_to_save.product_id ]).nil?
  		    		
  		    logger.error("Application for #{@model_id.year} #{@model_id.model} - #{@model_id.description}, | 															#{@mpc_to_save.category_id} | #{@product.product_number} Already Exists.")	  
  		    flash.now[:notice] = "Application for #{@model_id.year} #{@model_id.model} - #{@model_id.description}, | 													#{@mpc_to_save.category_id} | #{@product.product_number} Already Exists."
  		    render :update do |page|
  	    	page.insert_html :top, 'results', :partial => 'add_results'
  	  	    end
  		else
	  	  @mpc_to_save.save  		
  	
  		  @mod_sum = ModelSummary.find(@atv_model[0])
  		  @mod_sum_hash = Array.new  	
  		  @years = Model.get_years_by_mod_sum(@mod_sum.id, @product.product_id)
  		  for year in @years
  		    @mod_sum_hash << year.year
  		  end  	 
  	
  		  render :update do |page|
  		    page.insert_html :top, 'results', :partial => 'add_results'
  		    page.insert_html :top, @atv_model[0], :partial => 'mpc_added_row'  
  		    page.replace_html @mod_sum.id.to_s+"_newrow", :partial => 'new_row'
  		  end  
  	    end 	
      end
    end
  end
  
  # ------------------------------------------
  # scaffold methods review later for deletion
  # ------------------------------------------
  
  # GET /model_product_categories/new
  # GET /model_product_categories/new.xml
  def new
    @model_product_category = ModelProductCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @model_product_category }
    end
  end

  # GET /model_product_categories/1/edit
  def edit
    @model_product_category = ModelProductCategory.find(params[:id])
  end

  # POST /model_product_categories
  # POST /model_product_categories.xml
  def create
    @model_product_category = ModelProductCategory.new(params[:model_product_category])

    respond_to do |format|
      if @model_product_category.save
        flash[:notice] = 'ModelProductCategory was successfully created.'
        format.html { redirect_to(@model_product_category) }
        format.xml  { render :xml => @model_product_category, :status => :created, :location => @model_product_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @model_product_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /model_product_categories/1
  # PUT /model_product_categories/1.xml
  def update
    @model_product_category = ModelProductCategory.find(params[:id])

    respond_to do |format|
      if @model_product_category.update_attributes(params[:model_product_category])
        flash[:notice] = 'ModelProductCategory was successfully updated.'
        format.html { redirect_to(@model_product_category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @model_product_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /model_product_categories/1
  # DELETE /model_product_categories/1.xml
  def destroy
    @model_product_category = ModelProductCategory.find(params[:id])
    @model_product_category.destroy

    respond_to do |format|
      format.html { redirect_to(model_product_categories_url) }
      format.xml  { head :ok }
    end
  end
end
