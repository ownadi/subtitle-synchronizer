require 'rspec'
require_relative '../subtitle_synchronizer'

describe SubtitleSynchronizer do

  context 'with correct input data' do

    before { @editor = SubtitleSynchronizer.new('fixtures\test_data.txt') }

    it 'can read the subtitles file' do
      data = @editor.subs

      data.should be_a(Array), 'Data is not an array.' #array of lines
      data.size.should eq(2), 'Data has no 2 lines.' #test data has 2 lines
    end

  it 'can get parts of line' do

      first_line = @editor.subs.first

      parts = @editor.send(:get_parts, first_line)

      parts[:char].should eq('{'), 'First char does not match.'
      parts[:start_frames].should eq(5121), 'Start frames do not match.'
      parts[:end_frames].should eq(5166), 'End frames do not match.'
      parts[:text].should eq('Reklama jest trywialna.|Manipuluje i jest wulgarna.'), 'Text part does not match.'

    end

    it 'can add/sub frames and return corrected subs' do
      @editor.add_frames(4)
      @editor.subs[0].should eq '{5125}{5170}Reklama jest trywialna.|Manipuluje i jest wulgarna.'
      @editor.subs[1].should eq '[5170][5191]Tak samo prawo.'

      @editor.sub_frames(10)
      @editor.subs[0].should eq '{5115}{5160}Reklama jest trywialna.|Manipuluje i jest wulgarna.'
      @editor.subs[1].should eq '[5160][5181]Tak samo prawo.'
    end
  end

  it 'should raise exception when invalid input' do
    expect { SubtitleSynchronizer.new('fixtures\invalid_test_data') }.to raise_error('Make sure your subs are in correct format!'), 'Exception was not raised.'
  end

end