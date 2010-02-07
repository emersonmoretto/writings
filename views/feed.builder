xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
	xml.title Blog.title
	xml.id Blog.url
	xml.updated @articles.first[:created_at] if @articles.any?
	xml.author { xml.name Blog.author }

	@articles.each do |article|
		xml.entry do
			xml.title article[:title]
			xml.link "rel" => "alternate", "href" => article.url
			xml.id  article.url
			xml.published article[:created_at]
			xml.updated article[:created_at]
			xml.author { xml.name Blog.author }
			xml.summary article.summary_html, "type" => "html"
			xml.content article.body_html, "type" => "html"
		end
	end
end
