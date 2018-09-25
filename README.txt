Project: webCrawl.rb
Author: Kevin Lane

This program creates a WebCrawler class, which is designed to be initialiazed 
with a domain in mind.  It contains a method to list all of the possible links
from a given webpage, a method to determine if a link is broken or not, and
a method to recursively explore all of the pages reachable from the starting
url that are in the given domain.  If a link on a given page is broken, it 
appends it to a list of broken links.  The program creates a WebCrawler class
object with the bowdoin.edu domain, calls the explore function, and then
prints out the broken links.  There is a commented out section which also
allows for printing out all visited links.

Things of note:

- When running on the testbed and the computer-science domains, the program 
works without problems.  When running on the bowdoin.edu domain, I encountered
UTF-8 encoding errors for certain webpages that crashed the program.  I have
a rescue call in place that notes where the UTF-8 encoding error occurs and
allows the program to continue.

- Systems emailed me asking that I not crawl through pages outlined on the
bowdoin.edu/robots.txt page, so my explore function ignores those pages.

