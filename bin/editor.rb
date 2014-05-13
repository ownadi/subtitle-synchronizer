require '../lib/subtitle_synchronizer'

begin
  file_name = String(ARGV[0])
  count = Integer(ARGV[1])
rescue
  $stderr.puts "Usage: #{File.basename(__FILE__)} file_name count"
  exit 1
end

begin
  synchronizer = SubtitleSynchronizer.new(file_name)
rescue Exception => e
  $stderr.puts e.message
  exit 2
end

synchronizer.add_frames(count)
puts synchronizer.subs

$stderr.puts "Done!"