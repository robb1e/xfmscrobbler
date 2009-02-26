require 'rubygems'
require 'scrobbler'
require 'net/http'
require 'uri'

page = Net::HTTP.get(URI.parse('http://www.xfm.co.uk/onair/playlist/recent'))
recentTrackTable = page.scan(/<table cellspacing="0" class="playlist">[\S\s]*table>/).to_s
artists = recentTrackTable.scan(/">[A-Z0-9 '&]+</)
tracks = recentTrackTable.scan(/span>[A-Zth0-9 ()'&]+</)
times = recentTrackTable.scan(/100">[A-Za-z0-9 :,]+</)

auth = Scrobbler::SimpleAuth.new(:user => 'xfmbot', :password => '***')
auth.handshake!

count = 0
while count < artists.length

	month = times[count].scan(/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)/)
	dt = times[count].gsub("100\">", "").scan(/[0-9:]+/)
	scrobble = Scrobbler::Scrobble.new(:source => 'R', :session_id => auth.session_id, :submission_url => auth.submission_url, :artist => artists[count].gsub("\">","").gsub("<",""), :track => tracks[count].gsub("span>","").gsub("<",""), :album => '', :time => Time.parse(dt[1]), :length => '', :track_number => '')
	scrobble.submit!
	puts artists[count].gsub("\">","").gsub("<","")
	puts tracks[count].gsub("span>","").gsub("<","")
	puts Time.parse(dt[1])
	#puts scrobble.status
	count += 1

end
