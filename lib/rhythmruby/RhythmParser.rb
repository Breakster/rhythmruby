
# Parser (use as class) of the rhythm strings, consisting event and silence symbols
class RhythmParser
  @@silenceNote = 1 # pitch of a note played at during initial silence in a sequence
  @@silenceMark = '-' # symbol identified as a silence
  @@eventMark = '#' # symbol identified as an event
  @@eventNote = 50 # (unused default) midi note of an event
  @@countBase = 1.0/4.0 # (unused default) time duration of one symbol in quarter note lengths
  
  # parses the rhythm string and generates midi info ready for MidiWriter
  # side note:  a string starting with a silence needs an initial 'silence note' (note value: @@silenceNote)
  # @param [String] rhythmString sequence of silence and event markers
  # @param [Float] countBase rhyhtmic length of one symbol (in quarternote units)
  # @param [Fixnum] midiNote note assigned to events in the parsed output
  # @return [Array<Array>] midiSequence array of [midiNote, noteLength]
  #   can be written to midi with midiWriter.writeSegToTrack
  def self.parseRhythm(rhythmString, countBase, midiNote)
    @@countBase = countBase # time duration of one symbol (quarternote lengths)
    @@eventNote = midiNote # midi note assigned to events
    
    midiSequence = [] # empty array to store parsed midi data
    curNote = nil # initialize current midi note
    curLen = nil  # initialze current midi note length
    first = true # state variable testing for first / sequential events
    
    rhythmString.each_char do
      |symbol| # symbol in the string either a silence or an event
      
      if first # if true this is the first parsed symbol
        first = false # skip on next symbol
        
        # if first symbol is an event (handles when the rhythm starts with a silence)
        if symbol == @@eventMark 
          curNote = @@eventNote
          curLen = 1
          
        elsif symbol == @@silenceMark
          curNote = @@silenceNote
          curLen = 1
          
        end 
      else # when first symbol has already been parsed
        if symbol == @@eventMark # an event is parsed, write previous event and generate new one
            # add midi event to midiSequence (note length in countbase units)
            midiSequence << [curNote,(curLen*@@countBase)] 
            curNote = @@eventNote # generate new event
            curLen = 1 # reset note length to 1
          
        elsif symbol == @@silenceMark # a silence is parsed
          curLen += 1 # add one countbase note length to the current note
        
       end
     end
    end
    
    return midiSequence
  end
end

