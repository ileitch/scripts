# Analyze heap dump from Memprof.

lines = File.readlines('/tmp/objects.json');nil

objs = {}

lines.each do |line|
  line = JSON.parse(line)
  objs[line['class_name']] ||= {}
  location = "#{line['file']}:#{line['line']}"
  objs[line['class_name']][location] ||= 0
  objs[line['class_name']][location] += 1
end;nil

objs.each do |obj, lines|
  next unless obj
  lines = lines.sort_by {|_, count| count }.reverse
  puts obj
  puts "=" * obj.size
  lines.each { |location, count| puts "#{count}\t\t#{location}" }
end;nil
