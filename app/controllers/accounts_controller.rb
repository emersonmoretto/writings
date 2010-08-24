class AccountsController < ApplicationController
  
  def login
    respond_to :html
  end
  
  def logout
    session[:user] = nil    
    redirect_to :controller=>"articles", :action=>"index"
  end
  
  def doLogin
    login = params[:login]    
    passwd = params[:passwd]
    
    #Apache Basic auth    
    url="http://intranet.saudedigital.org.br"
    url=URI.parse(url)
    http=Net::HTTP.new(url.host,url.port)
    result_code = 0
    
    #doing the request
    Net::HTTP.start(url.host) do http
        req=Net::HTTP::Get.new('http://intranet.saudedigital.org.br')
        req.basic_auth login, passwd
        resp=http.request(req)
        result_code = resp.code
     end       
    
    #checking result_code  
    if result_code == '301'        
      session[:user] = login
      redirect_to :controller=>"articles", :action=>"admin"
      return
    else
      flash[:notice] = "Try again, wrong password!"
      redirect_to :action=>"login"
    end    
     
  end
  
end