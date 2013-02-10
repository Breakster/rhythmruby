# ruby version testing
versionInfo = RUBY_VERSION.split('.').map{|num| num.to_i}

if versionInfo[1]==9
  require "rhythmruby"
elsif versionInfo[1]<=8
  require "rubygems"
  require "rhythmruby"
end

# In this example we recreate the initial drum pattern of the song:
#'Perpetual Black Second' by Meshuggah, as played on the album Nothing (2002)
# hi-hat and snare are quite straightforward, but we will use
# RhythmRuby to concisely capture the polyrhythmics in the kick pattern

fileName = 'Meshuggah.midi'
bpm = 140 # beats per minute of midi Song
countBase = 1.0/4.0 # countbase in multiples/divisions of the quarternote (1/4 countbase is sixteenth notes, 4 notes per quarter note)

# define midiNotes for the midi percussion tracks,
# these default notes work with the Hydrogen sampler
midiNotes = {'kick'=>36, 'snare'=>38, 'hihat'=>42}

# empty hash to store rhythm parameters
stringParam ={'kick'=>{}, 'snare'=>{}, 'hihat'=>{}}


# create rhythm by specifying snippets and snippet patterns

# basic quarter note beat on the hihat
stringParam['hihat']['snippetL'] = [4] # snippet has length of 4 sixteenth notes (see countBase)
stringParam['hihat']['eventPos'] = [[0]] # event/hit happens at position 0
stringParam['hihat']['idx'] = [0] # only snippet '0' is repeated
stringParam['hihat']['nRep'] = [32] # repeat the snippet 32 times (32 quarternotes)
stringParam['hihat']['rhythmRep'] = 1 # repeat this rhythm once

# snare pattern of four quarter note, snare on third quarter note
stringParam['snare']['snippetL'] = [4,4] # two snippets of length 4 sixteenth notes
stringParam['snare']['eventPos'] = [[], [0]] #. one snippet with hit on first sixteenth note and one empty snippet
stringParam['snare']['idx'] = [0,0,1,0] # pattern of snippets (empty, empty, hit, empty)
stringParam['snare']['nRep'] = nil # repeat snippets once
stringParam['snare']['rhythmRep'] = 8 # repeat complete rhythm 8 times


# interesting kick pattern of 14 sixteenth notes long, it shifts respective to the hi-hat
# it can be understood as 7/8 (kick) over 4/4 (snare) polyrhythmic 
stringParam['kick']['snippetL'] = [14, 2] # main pattern and 2 note filler at end

# the main 14 sixteenth note snippet looks like this: #--#--#-##-#--
stringParam['kick']['eventPos'] = [[0, 3, 6, 8, 9, 11],[0]] # positions at which hits/events occur per snippet
stringParam['kick']['idx'] = [0,1] # sequential order of snippets, first repeat main snippet then add filler
stringParam['kick']['nRep'] = [9,1] # repeat main snippet 9 times, then play filler pattern once
stringParam['kick']['rhythmRep'] = 1 # repeat total rhythm once

# for each instrument
# create rhythm snippet strings and combine them in a rhythm string
rhythms = {} # empty hash for storing rhythms per instrument
stringParam.each_key do
  |instr|
  snippets = RhythmCompiler.createSnippets(stringParam[instr]['snippetL'],stringParam[instr]['eventPos'])
  # compile rhythm pattern/string
  rhythms[instr] = RhythmCompiler.createRhythm(snippets, stringParam[instr]['idx'], stringParam[instr]['nRep'], stringParam[instr]['rhythmRep'])

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

midiWriter.mergeTracks
# write the midiSong to a file
midiWriter.writeToFile(fileName)
