require 'rubygems'
require 'sinatra'

# sinatra configure
configure do
  require 'ostruct'
  Blog = OpenStruct.new(
    :title => 't.log',
    :author => 'Thiago Moretto',
    :url => 'http://localhost:4567/',             
    :disqus_shortname => 'tdotlog',
    :summary => { :max => 150, :delim => /~\n/ } 
    )
end                

error do
	e = request.env['sinatra.error']
	puts e.to_s
	puts e.backtrace.join("\n")
	"Application error"
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
                  
require 'tlog'

layout 'layout'

# 
# Index/MainPage
#
get '/' do
  articles = TLOG::Site.articles(".markdown").reverse.map do |a|
    TLOG::Article.new(File.new(a), Blog)
  end
	
	erb :index, :locals => { :articles => articles }, :layout => false
end
            
#
# Article/Post
#                     
get '/:year/:month/:day/:slug/' do                                                                                      
  file = "articles/#{params[:year]}-#{params[:month]}-#{params[:day]}-#{params[:slug]}.markdown"
  article = TLOG::Article.new(File.new(file), Blog)
  stop [ 404, "Article not found"] unless article
  erb :article, :locals => { :article => article, :title => "# cat #{file}" }
end           
              
#
# Full Archive
#
get '/archive' do                 
  articles = TLOG::Site.articles(".markdown").reverse.map do |a|     
    TLOG::Article.new(File.new(a), Blog)
  end
  
  erb :archive, :locals => { :articles => articles, :title => '# cat t.log' }     
end

get '/feed' do      
  @articles = TLOG::Site.articles(".markdown").reverse.map do |a|     
    TLOG::Article.new(File.new(a), Blog)
  end
  
  content_type 'application/atom+xml', :chartset => 'utf-8'
  builder :feed
end
            
get '/rss' do
  redirect '/feed', 301
end       

get '/about' do
   erb :about, :locals => { :title => '# who am i'}
end
