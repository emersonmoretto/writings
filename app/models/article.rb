require 'maruku'

class Article < ActiveRecord::Base
      
  PAGE_SIZE = 5.0
  
  scope :published, where(:published => true).order("created_at DESC")
  scope :all, order("created_at DESC") 
  scope :recent, limit(10).order("created_at ASC")
  scope :author, proc {|author| where(:author => author) }
  scope :tag, proc {|tag| where("tags like '%#{tag}%'") }
  scope :page, proc {|page| limit(PAGE_SIZE).offset(PAGE_SIZE*(page-1)) }
    
  def to_param 
    "#{id}-#{title.parameterize}" 
  end 
  
  def self.all_tags
    set = Set.new
    Article.all.each do |a|
      a.tags.split(",").each do |tag|
        set.add tag.strip
      end
    end
    return set
  end
        
  def to_html      
     doc = Maruku.new(content)
     doc.to_html
  end
  
  def self.page_count
    (Article.published.count / PAGE_SIZE).ceil
  end
  
end
