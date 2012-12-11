lines = File.readlines('/tmp/heap.json');nil

objs = {'node' => {}, 'frame' => 0, 'globals' => 0, 'finalizers' => 0,
        'iclass' => {}, 'hash' => 0, 'string' => 0, 'array' => 0, 'data' => {},
        'regexp' => {}, 'class' => {}, 'object' => {}, 'struct' => {},
        'module' => {}, 'scope' => 0, 'float' => {}, 'varmap' => 0,
        'file' => {}, 'bignum' => {}, 'match' => {}, 'lsof' => 0}

lines.each do |line|
  line = JSON.parse(line)

  case line['type']
  when 'node'
    location = "#{line['file']}:#{line['line']}"
    objs['node'][location] ||= 0
    objs['node'][location] += 1
  when 'frame'
    objs['frame'] += 1
  when 'globals'
    objs['globals'] += 1
  when 'finalizers'
    objs['finalizers'] += 1
  when 'iclass'
    objs['iclass'][line['name']] ||= 0
    objs['iclass'][line['name']] += 1
  when 'class', 'module'
    objs['class'][line['super_name']] ||= 0
    objs['class'][line['super_name']] += 1
  when 'string', 'hash', 'array'
    objs[line['type']] += 1
  when 'data', 'object', 'regexp', 'struct', 'float', 'file', 'bignum', 'match'
    objs[line['type']][line['class_name']] ||= 0
    objs[line['type']][line['class_name']] += 1
  when 'scope'
    objs['scope'] += 1
  when 'varmap'
    objs['varmap'] += 1
  when 'lsof'
    objs['lsof'] += 1
  when 'ps'
  else
    p line
    raise StandardError, line['type']
  end
end;nil

def list(data)
  data = data.sort_by {|_, count| count }.reverse
  data.each { |thing, count| puts "#{count}\t\t#{thing}" }
end

objs.each do |type, data|
  puts
  puts type
  puts "=" * type.size

  case type
  when 'node', 'data', 'object', 'regexp', 'struct', 'float', 'file', 'bignum', 'match', 'iclass', 'class', 'module'
    list(data)
  else
    puts data
  end
end;nil
