class Article < ActiveRecord::Base
  
  scope :all, :order => "created_at DESC"  
  scope :recent,   limit(10).order("created_at ASC")
  scope :author,   proc {|author| where(:author => author) }
  scope :tag, proc {|tag| where("tags like '%#{tag}%'") }
  scope :page, proc {|page| limit(5).offset(5*(page-1)) }
    
  def to_param 
    "#{id}-#{title.parameterize}" 
  end 
    
end
