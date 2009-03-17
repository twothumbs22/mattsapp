class ModelsController < ApplicationController
	
  def rebuild_model_summary
  	
  end
  
  def clear_model_summary_table
	ModelSummary.delete_all()
  end
  
  def update_model_summary_table
  	@model_summary = Model.get_distinct_models
  	for item in @model_summary
  		ModelSummary.new do |m|
  		m.description = item.description
  		m.cc = item.cc
  		m.model_name = item.model
  		m.make = item.make
  		m.save
  		end
  	end  	
  end
  
  def relink_model_and_summary_ids
  	@sql = "UPDATE models a, model_summaries b SET a.model_summary_id = b.id WHERE a.description = b.description AND a.make = b.make AND a.cc = b.cc"
  	@updated = ActiveRecord::Base.connection.execute(@sql)   	
  end
  
  def update_model_summary_years
  	@model_summary = ModelSummary.find(:all)
  	for item in @model_summary
  	  @beg_year = @end_year = @mid_year1 = @mid_year2 = ''
  	  @year = 0
	  for a in item.models
	  	if @year == 0
	  		@beg_year = a.year.to_s
	  		@year += 1
  		else
  			if @end_year != '' && (a.year-1).to_s > @end_year
  				@mid_year1 = @end_year  				
  				@end_year = @mid_year2 = a.year.to_s
  			elsif @end_year == '' && @beg_year < (a.year-1).to_s
  				@mid_year2 = a.year.to_s				
  				@end_year = a.year.to_s
  		    else 
  				@end_year = a.year.to_s  		    	
  			end
  		end	
  	  end
  	  if @mid_year2 != '' && @mid_year2 < @end_year
  	  	if @mid_year1 == ''
  	  		@years = @beg_year.slice(2,3)+','+@mid_year2.slice(2,3)+'-'+@end_year.slice(2,3)	
  	  	else
  	  		@years = @beg_year.slice(2,3)+'-'+@mid_year1.slice(2,3)+','+@mid_year2.slice(2,3)+'-'+@end_year.slice(2,3)	
  	  	end
  	  elsif @mid_year2 != '' && @mid_year2 == @end_year
  	  	if @mid_year1 == ''
  	  		@years = @beg_year.slice(2,3)+','+@end_year.slice(2,3)
  	  	else
  	  	  	@years = @beg_year.slice(2,3)+'-'+@mid_year1.slice(2,3)+','+@end_year.slice(2,3)	  		
  	  	end  	  	
  	  elsif @end_year == ''
  	    @years=@beg_year.slice(2,3) 	  	
   	  else 
  	    @years=@beg_year.slice(2,3)+"-"+@end_year.slice(2,3)
  	  end
  	  @update_years_model_summary = ModelSummary.find(item.id)
  	  @update_years_model_summary.years = @years.to_s
  	  @update_years_model_summary.save
    end
  	@model_summary = ModelSummary.find(:all)
  end
	
	
	
  # GET /models
  # GET /models.xml
  def index
    @models = Model.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @models }
    end
  end

  # GET /models/1
  # GET /models/1.xml
  def show
    @model = Model.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @model }
    end
  end

  # GET /models/new
  # GET /models/new.xml
  def new
    @model = Model.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @model }
    end
  end

  # GET /models/1/edit
  def edit
    @model = Model.find(params[:id])
  end

  # POST /models
  # POST /models.xml
  def create
    @model = Model.new(params[:model])

    respond_to do |format|
      if @model.save
        flash[:notice] = 'Model was successfully created.'
        format.html { redirect_to(@model) }
        format.xml  { render :xml => @model, :status => :created, :location => @model }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /models/1
  # PUT /models/1.xml
  def update
    @model = Model.find(params[:id])

    respond_to do |format|
      if @model.update_attributes(params[:model])
        flash[:notice] = 'Model was successfully updated.'
        format.html { redirect_to(@model) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /models/1
  # DELETE /models/1.xml
  def destroy
    @model = Model.find(params[:id])
    @model.destroy

    respond_to do |format|
      format.html { redirect_to(models_url) }
      format.xml  { head :ok }
    end
  end
end
