class SubtitleSynchronizer
  attr_reader :subs

  @@regs = {'{' => /{([^}]*)}{([^}]*)}([^\r\n]*)/, '[' => /\[([^\]]*)\]\[([^}]*)\]([^\r\n]*)/}

  def initialize(file_name)
    data_file = File.open(file_name)
    @subs = data_file.readlines

    #validating
    @subs.each do |line|
      correct_line = @@regs[line[0]]
      correct_line = correct_line.match(line) unless correct_line.nil? #first char is ok - let's try deeper
      fail 'Make sure your subs are in correct format!' if correct_line.nil? #is everything ok?
    end
  end

  def add_frames(count)
    @subs.map! do |line|
      parts = get_parts(line)
      #parts.map! { |time| time.instance_of?(Fixnum) ? time += count : time } #changing frames
      parts[:start_frames] = (parts[:start_frames] + count).to_s + (parts[:char].ord + 2).chr
      parts[:end_frames] = parts[:char] + (parts[:end_frames] + count).to_s + (parts[:char].ord + 2).chr
      line = parts.values.join
    end
  end

  def sub_frames(count)
    add_frames(-count)
  end

  private
  def get_parts(line)
    match_captures = @@regs[line[0]].match(line).captures #it's safe - file is already verified

    #[] << match_captures[0].to_i << match_captures[1].to_i << match_captures[2] #return array with parts
    {char: line[0], start_frames: match_captures[0].to_i, end_frames: match_captures[1].to_i, text: match_captures[2]} #return hash of parts
  end
end