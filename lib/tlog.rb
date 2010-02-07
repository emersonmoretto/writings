require File.dirname(__FILE__) + '/../vendor/maruku/maruku'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../vendor/syntax'
require 'syntax/convertors/html'

### Indexacao com Ferret!      

### Site
module TLOG
  class Site
    def self.articles ext       
      # TODO: Parametrizar
      Dir['articles/*.txt']
    end
  end
                                           
  class Article < Hash
     def initialize(obj, config)
       @obj, @config = obj, config
       self.load if obj.is_a? Hash
     end        
     
     def load
       data = if @obj.is_a? File
         meta, self[:body] = @obj.read.split(/\n\n/, 2)
         YAML.load(meta)
       elsif @obj.is_a? Hash 
         @obj
       end.inject({}) {|h, (k,v)| h.merge(k.to_sym => v) }      
                                       
       # ToDo
       
       self.taint
       self.update data
       self[:date] = Time.parse(self[:date].gsub('/', '-')) rescue Time.now
       self[:created_at] = DateTime.now        
       self
     end       

     def [] key
       self.load unless self.tainted?
       super
     end

     # ToDo
     def linked_tags
      ""
     end   
     
     # ToDo
     def summary_html
       ""
     end   
     
     # ToDo
     def more?
       false
     end
  
     def method_missing m, *args, &blk
       self.keys.include?(m) ? self[m] : super
     end   
      
     def url
        "http://#{(@config.url.sub("http://", '') + self.path).squeeze('/')}"
     end                    
               
     def summary length = nil
       length ||= (config = @config.summary).is_a?(Hash) ? config[:max] : config

       sum = if self[:body] =~ config[:delim]
         self[:body].split(config[:delim]).first
       else
         self[:body].match(/(.{1,#{length}}.*?)(\n|\Z)/m).to_s
       end
       to_html (sum.length == self[:body].length ? sum : sum.strip.sub(/\.\Z/, '&hellip;'))
     end
     
     def slug
       self[:slug] ||
          self[:title].downcase.gsub(/&/, 'and').gsub(/\s+/, '-').gsub(/[^a-z0-9-]/, '')
     end
               
     def path
       self[:date].strftime("/%Y/%m/%d/#{slug}/") 
     end
     
     def body
        to_html self[:body]
     end    
     
     def summary_html
        summary
     end
     
     def body_html
        to_html(self[:body])         
     end
              
     def to_html(markdown)
       	out = []
     		noncode = []
     		code_block = nil
     		markdown.split("\n").each do |line|
     			if !code_block and line.strip.downcase == '<code>'
     				out << Maruku.new(noncode.join("\n")).to_html
     				noncode = []
     				code_block = []
     			elsif code_block and line.strip.downcase == '</code>'
     				convertor = Syntax::Convertors::HTML.for_syntax "ruby"
     				highlighted = convertor.convert(code_block.join("\n"))
     				out << "<code>#{highlighted}</code>"
     				code_block = nil
     			elsif code_block
     				code_block << line
     			else
     				noncode << line
     			end
     		end
     		out << Maruku.new(noncode.join("\n")).to_html
     		out.join("\n")
     end
        
     alias :to_s to_html    
     
  private
    def markdown text
      text.strip
    end
  end
end