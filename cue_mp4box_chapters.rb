require 'rubycue'
require 'optparse'

options = {}
 
opts = OptionParser.new do |opts| 
    opts.on("-c", "--cue PATH", "Path to chesheet file") do |cue_file|
      options[:cue] = cue_file
    end
end
 
opts.parse!

cuesheet = RubyCue::Cuesheet.new(File.read(options[:cue]))
cuesheet.parse!

chapter_file = File.path(options[:cue]).gsub(File.extname(options[:cue]),".chapters")

chapters=""

cuesheet.songs.each_with_index do |song, i|
	num = i+1
    title = "#{song[:performer]} - #{song[:title]}"

    hour = song[:index].minutes / 60
    hour = hour.floor
    minutes = song[:index].minutes % 60
    seconds = song[:index].seconds
    chapters << "CHAPTER#{num}=#{hour}:#{minutes}:#{seconds}\n"
    chapters << "CHAPTER#{num}NAME=#{title}\n"
end

File.open(chapter_file, 'w') { |f| f.write(chapters) }
