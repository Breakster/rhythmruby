# ruby version testing
versionInfo = RUBY_VERSION.split('.').map{|num| num.to_i}

if versionInfo[1]==9
  require "RhythmRuby"
elsif versionInfo[1]<=8
  require "rubygems"
  require "RhythmRuby"
end

fileName = 'test.midi'
bpm = 140 # beats per minute of midi Song
midiNote = 46 # midiNote of events, we are testing with one instrument, so one note
countBase = 1.0/4.0 # countbase in multiples/divisions of the quarternote (1/4 countbase is sixteenth notes, 4 notes per quarter note)

# note 36=kick, 38=snare 46=hi-hat

# snippet creation parameters
snippetLengths = [5] # length per snippet (or length for all snippets, if snippeLength.length == 1)
eventPositions = [[0]] # positions per snippet, where events happen (zero-based)

# pattern creation parameters
snippetIdx = [0]*10 # indexes of snippets to be added sequentially to the rhythm string
nRepeats = nil # number of repeats per snippet, if undefined (nil) all snippets are repeated once 


# create rhythm snippet strings
snippets = RhythmCompiler.createSnippets(snippetLengths, eventPositions)

puts 'snippets', snippets

# compile rhythm pattern/string
rhythm = RhythmCompiler.createRhythm(snippets, snippetIdx, nRepeats)

# print out the compiled rhythm
puts 'rhythm', rhythm

# parse the string and return the midi info
midiSequence = RhythmParser.parseRhythm(rhythm, countBase, midiNote)

# create the midiWriter instance, to write the midi info to a file
midiWriter = MidiWriter.new(bpm)

# create an empty midi track within the midiSong, to write the midi info to
midiTrack = midiWriter.createTrack()

# write the midi info/sequence to the midiTrack
midiWriter.writeSeqToTrack(midiSequence, midiTrack)

# write the midiSong to a file
midiWriter.writeToFile(fileName)
