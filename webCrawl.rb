=begin

Web Crawler
Author: Kevin Lane
Last Modified: 11/22/19

=end


load "open-uri.rb" # get the URI library

class WebCrawler
	attr_accessor :visited, :broken, :start, :allLinks, :badExtensions,
	 :noAccess, :domain

	def initialize(domain)
		@visited = Array.new
		@broken = Array.new
		@start = "http://www." + domain
		@domain = domain
		@allLinks = Array.new([@start])
		# I was told by Systems to not crawl through these extensions on Bowdoin.edu
		@badExtensions = ["/includes", "/scripts", "/alumni/pdf/", 
			"/chinesescrolls", "/alumni/cityguides", "/cgi-bin/", 
			"/visitors-friends/breakfast/", 
			"/news/archives/1bowdoincampus/001738.shtml", "/security/alerts/", 
			"/catalogue/archives/", "/polaris/degreeworks.shtml", "/digests/", 
			"/truman/", "/fdr/", "/atreus/", "/ZZ-Old/", "/BowdoinDirectory/", 
			"/calendar/", "/hoplite/", "/noindex/"]

		@noAccess = []

		# append the domain so we have the full link, 
		# and add it to @noAccess
		@badExtensions.each do |link|
			link = @start + link
			@noAccess.push(link)
		end
	end

	def getLinks(url)
		# scan the page for links
		# get a string of the content of the webpage
		content = open(url).read
		begin
			#look for links in the content
			links = content.scan(/<a\s+href="(.+?)"/i).flatten
			# handle relative links by adding domain
			final_links = []
			links.each do |oneLink|

			# if the link is relative
				if not oneLink.start_with?("http")
					#if it starts with /, then put bowdoin.edu is the parent url
					if oneLink.start_with?("/")
						final_links.push(oneLink.insert(0, "http://bowdoin.edu"))

					# if it's a directory change, ignore it
					elsif oneLink.start_with?("..")
						# do nothing

					# otherwise, the link doesn't start with /
					else
						# if the url ends with /
						if url.end_with?("/")
						# then just push it onto the parent url
							final_links.push(oneLink.insert(0, url))

						# if the parent url isn't a directory
						elsif url.end_with?("html")
							# get the parent url of the parent url
							rel_link = /[a-z]*\.[s]?[h][t][m][l]/.match(url).to_s
							parent = url.chomp(rel_link)
							final_links.push(oneLink.insert(0, parent))

						# otherwise, just insert an extra /
						else
							final_links.push(oneLink.insert(0, url + "/"))
						end
					end

				else
					final_links.push(oneLink)
				end
			end

			final_links

		rescue
			puts("There was a UTF-8 encoding error at the 
				following url: #{url}")
			final_links = []
		end
	end

	def explore()
		# as long as there are still links in allLinks
		while @allLinks.size != 0
		
			# set x equal to the first element of allLinks
			x = @allLinks[0]
		
			# if x is in our domain to search AND we haven't visited it yet
			if /#{Regexp.quote(@domain)}/.match(x) != nil and not @visited.include?(x)
		
				# if x is broken, add it to broken
				if broken?(x)
					@broken.push(x)
				
				# check if it is one of the links in @noAccess
				elsif not Regexp.union(@noAccess) === x

					# if it isn't, then we can crawl the url
					newLinks = getLinks(x)
					
					# add each link to allLinks
					newLinks.each do |oneLink|
					
						# make sure the link isn't already there
						if not @allLinks.include?(oneLink)
							@allLinks.push(oneLink)
						end
					end
				end	

				# add x to visited
				@visited.push(x)
			end

			# remove x from allLinks
			@allLinks.delete_at(0)
		end
	end

	def broken?(link)
		begin 
        	content = open(link).read
        	broken = false
      	rescue
        	broken = true
        end
	end	
end

crawler = WebCrawler.new("bowdoin.edu")
crawler.explore()


puts "There are #{crawler.broken.size} broken links"
puts "Here are the broken links: "

crawler.broken.each do |link|
	puts link
end

=begin
puts
puts "These ones were visited"


crawler.visited.each do |link|
	puts link
end
=end