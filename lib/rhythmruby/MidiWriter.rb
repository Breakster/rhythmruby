# ruby version testing
versionInfo = RUBY_VERSION.split('.').map{|num| num.to_i}

# MIDI interface was build on midilib, by Jim Menard, https://github.com/jimm/midilib
if versionInfo[1]==9
  require "midilib"
elsif versionInfo[1]<=8
  require "rubygems" 
  require "midilib"  
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