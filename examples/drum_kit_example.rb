# ruby version testing
versionInfo = RUBY_VERSION.split('.').map{|num| num.to_i}

if versionInfo[1]==9
  require "rhythmruby"
elsif versionInfo[1]<=8
  require "rubygems"
  require "rhythmruby"
end

fileName = 'drumtest.midi'
bpm = 120 # beats per minute of midi Song
countBase = 1.0/4.0 # countbase in multiples/divisions of the quarternote (1/4 countbase is sixteenth notes, 4 notes per quarter note)


midiNotes = {'kick'=>36, 'snare'=>38, 'hihat'=>42}
stringParam ={'kick'=>{}, 'snare'=>{}, 'hihat'=>{}}


# parameters for rhythm composition
stringParam['hihat']['snippetL'] = [4]
stringParam['hihat']['eventPos'] = [[0]]
stringParam['hihat']['idx'] = [0]
stringParam['hihat']['nRep'] = nil
stringParam['hihat']['rhythmRep'] = 2*60/4

stringParam['snare']['snippetL'] = [4,5,4]
stringParam['snare']['eventPos'] = [[],[0],[0]]
stringParam['snare']['idx'] = [0,1,0,1,0,1,0,1,2]
stringParam['snare']['nRep'] = nil
stringParam['snare']['rhythmRep'] = 2*60/(40)

stringParam['kick']['snippetL'] = [5]
stringParam['kick']['eventPos'] = [[0,2]]
stringParam['kick']['idx'] = [0]
stringParam['kick']['nRep'] = [1]
stringParam['kick']['rhythmRep'] = 2*60/5

# for each instrument
# create rhythm snippet strings and combine them in a rhythm string
rhythms = {} # empty hash for storing rhythms per instrument
stringParam.each_key do
  |instr|
  snippets = RhythmCompiler.createSnippets(stringParam[instr]['snippetL'],stringParam[instr]['eventPos'])
  # compile rhythm pattern/string
  rhythms[instr] = RhythmCompiler.createRhythm(snippets, stringParam[instr]['idx'], stringParam[instr]['nRep'])*stringParam[instr]['rhythmRep']

end

# print out the compiled rhythm
puts 'rhythm'
for instr in ['hihat','snare','kick']
  puts rhythms[instr]
end


# create the midiWriter instance, to write the midi info to a file
midiWriter = MidiWriter.new(bpm) # instance creates a midi song with a fixed bpm

# parse and write rhythm to midi track for each instrument
rhythms.each_key do
  |instr|
  # parse the string and return the midi info
  midiSequence = RhythmParser.parseRhythm(rhythms[instr], countBase, midiNotes[instr])
  
  # create an empty midi track within the midiSong, to write the midi info to
  midiTrack = midiWriter.createTrack()
  
  # write the midi info/sequence to the midiTrack
  midiWriter.writeSeqToTrack(midiSequence, midiTrack)

end

# write the midiSong to a file
midiWriter.writeToFile(fileName)
