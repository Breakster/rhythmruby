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

# quarternote beat on the hi-hat
stringParam['hihat']['snippetL'] = [4] # snippet is 4 siixteenthnotes long (one quarternote)
stringParam['hihat']['eventPos'] = [[0]] # hi-hat hit is on the first sixteenth note (the beat)
stringParam['hihat']['idx'] = [0] # rhythm is made up out of one snippet
stringParam['hihat']['nRep'] = [8] # repeat snippet 30 times for 30 quarternotes
stringParam['hihat']['rhythmRep'] = 1 # repeat total rhythm once for 8 beat bar


# snare on two and four
stringParam['snare']['snippetL'] = [4,4] # two snippets of 4 sixteenth notes
stringParam['snare']['eventPos'] = [[],[0]] # two snippets, one has no hits, one has it on the first sixteenth note
stringParam['snare']['idx'] = [0,1] # alternate the two snippets
stringParam['snare']['nRep'] = nil # play snippets once before alternating
stringParam['snare']['rhythmRep'] = 4 # repeat the two beat rhythm 4 times for 8 beat bar

# kick on first two eight notes
stringParam['kick']['snippetL'] = [4,4] # two snippets of length 4
stringParam['kick']['eventPos'] = [[0,2],[]] # kick on first and third sixteenth note and empty snippet
stringParam['kick']['idx'] = [0,1] # alternate the snippets
stringParam['kick']['nRep'] = nil # play snippets once before alternating
stringParam['kick']['rhythmRep'] = 4 # repeat rhythm 4 times for 8 beat bar

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
for instr in ['hihat', 'snare', 'kick']
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
