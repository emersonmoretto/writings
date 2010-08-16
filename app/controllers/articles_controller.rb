class ArticlesController < ApplicationController
  
  before_filter :filter, :except=> [:show,:index,:tag,:page] 
  
  def filter
      if session[:user].nil?
        redirect_to :controller=>"accounts", :action=>"login"
      return
    end
  end
  
  def index
    @articles = Article.published    
  end
  
  def page    
    @articles = Article.page params[:id].to_i if !params[:id].nil?
    render :index    
  end

  def tag    
    @articles = Article.tag(params[:id])
    render :index
  end
    
  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end
  
  def admin
    @articles = Article.all    
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to(@article, :notice => 'Article was successfully created.') }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to(@article, :notice => 'Article was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
  end
end
