class CategoriesController < ApplicationController
	
  def add_category
  	@top_level_cats = Category.find(:all, :conditions => "parent_id is null")
  	@cat_hash = @cat_hash2 = Hash.new	
  	@second_level_cats = @third_level_cats = Hash.new
  	for cat in @top_level_cats
  		@cat_hash[cat.category_id]= Category.count(:conditions => ["parent_id = ?", cat.category_id])
  		@second_level_cats[cat.category_id] = Category.find(:all, :conditions => ["parent_id = ?", cat.category_id])  	
  		for sub_cat in @second_level_cats[cat.category_id]
  			@cat_hash2[sub_cat.category_id]= Category.count(:conditions => ["parent_id = ?", sub_cat.category_id])
  			@third_level_cats[sub_cat.category_id] = Category.find(:all, :conditions => ["parent_id = ?", sub_cat.category_id])  	
	  	end  	
  	end  		
  end
	
  def show_cats
  	render :update do |page|
  	page.toggle params[:id]
  	end
  end
	
	
  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to(@category) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(@category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end
end
