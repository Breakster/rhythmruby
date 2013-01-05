# ruby version testing
versionInfo = RUBY_VERSION.split('.').map{|num| num.to_i}

if versionInfo[1]==9
  require "midilib"
  
elsif versionInfo[1]<=8
  require "rubygems" 
  require "midilib"
  
end

# rhythm composition class (use as a class)
# compiles rhythm snippets into a rhythm string/pattern
class RhythmCompiler
  @@silenceMarker = '-' # symbol for silence
  @@eventMarker = '#' # symbol for an event / hit
  
  # create an array of snippets of length in snippetLengths,
  # with events at position(s) in eventPositions
  # @param [Array<Fixnum>] snippetLengths length of each snippet
  #   (if snippetLengths.length == 1, length is constant for all snippets )
  # @param [Array<Array>] eventPositions containing arrays of event positions per snippet 
  #   (if eventPositions.length == 1, then event positions are constant for all snippets)
  # @return [Array<String>] snippets array of string rhythm snippets,
  #   for use with 'createString' method  
  def self.createSnippets(snippetLengths, eventPositions)
    snippets = [] # empty array to append the snippets
    
    # make input arrays suitable for fur
    if snippetLengths.length == 1
      # make snippetLengths as long as eventPositions      
      snippetLengths *= eventPositions.length 
             
    elsif eventPositions.length == 1 
     # make eventPositions as long as snippetLengths 
     eventPositions *= snippetLengths.length 
     
    else # both input arrays have more than one element and should be the same length
      if not(eventPositions.length == snippetLengths.length)
        raise ArgumentError, 'lengths of both arrays should be the same, \
         or one should have length 1'
      end
    end    
    
    #create a rhythm snippet for each set of event positions and snippetlength
    snippetLengths.zip(eventPositions).each do  
        |length, positions| # unpack the length and position information   
        # create a snippet of defined length consisting of silences
        snippet = @@silenceMarker*length 
                
        positions.each{|pos| # for each provided event positon of the snippet
          snippet[pos] = @@eventMarker # add an event marker at the position
        }
        
        snippets<<snippet # add the snippet to the returned snippets array
     end   
     return snippets # return the array with the snippets
  end
  
  
  # creates a rhythm string from rhythm snippets
  # @param [Array<String>] snippets array of rhythm snippets (from 'createSnippets)
  # @param [Array<Fixnum>] snippetIDx indexes, defining sequential order of snippets
  # @param [Array<Fixnum>] nRepeats defining how often snippets are repeated...
  #   if nil, all snippets are repeated once, if nRepeats.length==1, all snippets are repeated the same amount
  #   otherwise nRepeats should be the same length as snippetIdx and define repetition per snippet
  def self.createRhythm(snippets, snippetIDx, nRepeats)
    if nRepeats == nil # test whether nRepeats is defined, if not all snippets are repeated once
      nRepeats = [1]*snippetIDx.length # make nRepeats and snippetIDx the same length for iteration
    end 
    
    rhythmString = "" # empty string where all the snippets will be added to
    
    # iterate over combinations of snippetID and repeats
    snippetIDx.zip(nRepeats).each do
      |snippetID, repeats|
      # add the snippet with snippetID, repeat times, to the rhythm string 
      rhythmString += snippets[snippetID]*repeats 
    end
    
    return rhythmString # return the rhythm string ready for parsing
  end
end

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


# writes sequences of noteData (from a RhythmParser class) to midi tracks
# a 'MidiWriter' represents one midi Song, which can be written to one file,
# the midiSong can contain multiple tracks/noteSequences
#
# @param [Float] bpm beats per minute of the midi song/file that the tracks are part of
# @return [Object] MidiWriteInstance instance of the midi writer.
#   creator of one midi file with potential multiple tracks
class MidiWriter
  def initialize(bpm)
    @song = MIDI::Sequence.new() # this is a midi song/sequence
    @bpm = bpm # beats per minute of the midi song/sequence
  end  
  
  # creates a track within the midi song of current MidiWriter instance
  # @return [MIDI::Track] newTrack a new track within the midi song
  def createTrack()
     @song.tracks << (newTrack = MIDI::Track.new(@song))
     newTrack.events <<  MIDI::Tempo.new(MIDI::Tempo.bpm_to_mpq(@bpm))
     newTrack.events << MIDI::ProgramChange.new(0, 0)
     return newTrack
  end
  
  # writes a note sequence generate by a RhythmParser to a midi track
  # @param [Array<Array>] midiSeq an array of [midiNote, noteLength] (created by RhythmParser)
  # @param [MIDI:Track] midiTrack target track, generated with 'createTrack'.
  #   if a track is reused the event sequence will be appended
  def writeSeqToTrack(midiSeq, midiTrack)
    midiSeq.each do
      |midiNote, noteLength|    
      writeNote(midiNote, noteLength, midiTrack)
    end
  end
  
  # writes one midiNote to a midiTrack
  # @param [Fixnum] midiNote of the event to be written to a midiTrack
  # @param [Float] noteLength length of the midiEvent, in multiples of the quarternote
  # @param [MIDI::Track] midiTrack where the event is written to
  def writeNote(midiNote, noteLength, midiTrack)
      midiTrack.events << MIDI::NoteOnEvent.new(0, midiNote, 127, 0) 
      midiTrack.events << MIDI::NoteOffEvent.new(0, midiNote, 127, \
      @song.length_to_delta(noteLength))
  end

  # write the midiSong to file consisting of all the created midiTracks
  # @param [String] fileName where the midiSong is written to, can be a path 
  def writeToFile(fileName)
    open(fileName, 'w') {|f| @song.write(f) }
  end
end