RhythmRuby: Midi rhythms through string manipulation 
====================================================

**Author**:         Luuk van der Velden, (Amsterdam, 2013)
**Website**:
**Git**:


Synopsis
--------

RhythmRuby enables the creation of midi rhythms, through string manipulation. 
It provides methods for rhythm/string creation, parsing and writing to midi files.
Ruby and MIDI based rhythm delight!

Basics
------

**1. rhythm string** is a string consisting of two symbols,
one for silence (default '-') and one for an event or hit (default '#'). An example:
'#---#---#---#---', is read as one (drum) hit every three silences. 

**2. rhythm snippets** are the building blocks of a rhythm string. The
StringCompiler Class allows the creation of rhythm snippets and compiles them into a rhythm string.
These snippets capture the repetitive aspects of most rhythms.

**3. countBase** is the rhythmical length that is assigned to one symbol in a string.
It is measured in quartenote lengths (relative to bpm), thus countBase: 1.0, means one quarternote per symbol. 

**installation:** gem install rhythmruby

Classes
-------
The **RhythmCompiler** (class) generates rhythm snippets and combines these into rhythm strings.
These can be parsed to MIDI ready data by the **RhythmParser** (class).
The parsed output can be written to a MIDI file by the **MidiWriter** (class instance). 

Examples and Docs
-----
Check out the examples provided and the documentation based on YARD. The examples are aimed at 
creating single and multi instrument rhythms.

In the next minimal example we have skipped the creation of the rhythm string.
A predefined rhythm is written to midi.

**a minimal example**

    require 'rhythmruby'
    
    midiNote = 50 # midi note assigned to drum hits
    bpm = 120 # beats per minute of midi file
    fileName = 'testing.midi' # name of midi file
    
    countBase = 1.0/4.0 # one symbol represents a sixteenth note (one fourth of a quarternote)
        
    rhythm = '#---#---' # two quarternote drum hits, on sixteenth note base
    midiInfo = RhythmParser.parseRhythm(rhythm, countBase, midiNote)

    midiWriter = MidiWriter.new(bpm) # midiWriter instance administrating one MIDI song
    midiTrack = midiWriter.createTrack() # create track in the MIDI song
    midiWriter.writeSeqToTrack(midiInfo, midiTrack) # write the parsed rhythm to a MIDI track
    midiWriter.writeToFile(fileName) # write MIDI song to file

Rational
--------

RhythmRuby's strength lies in the rhythm string abstraction. It allows easy computer
manipulation of rhythm snippets to create rhythm patterns. These can then be
written to a midi file, possibly consisting of several tracks (f.i. hihat, snare, kick)

With RhythmRuby you can capture polyrhythmics at their essence by compiling rhythms out of
rhythm snippets and create midi drum tracks for further use in DAW's such as (cubase, logic, etc.)

RhythmRuby was made to create drum rhythms for my band Hologram Earth (www.hologramearth.nl)

Acknowledgment
--------------
thanks Jim Menard for **midilib**, a pure ruby MIDI library.
https://github.com/jimm/midilib
