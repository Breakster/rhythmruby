RhythmRuby: Midi rhythms through String manipulation 
====================================================

**Author**:         Luuk van der Velden, (Amsterdam, 2013)                                                                         
**Website**:                                                                                                                      
**Git**:            https://github.com/Lvelden/rhythmruby.git                                                                        

Synopsis
--------

RhythmRuby enables the creation of midi rhythms, through string manipulation. 
It provides methods for rhythm/string creation, parsing and writing to midi files.
Ruby and MIDI based rhythm delight!

Basics
------

**installation:** gem install rhythmruby

**1. rhythm string** is a string consisting of two symbols,
one for silence (default '-') and one for an event or hit (default '#'). An example:
'#---#---#---#---', is read as one (drum) hit every three silences. 

**2. rhythm snippets** are the building blocks of a rhythm string. The
StringCompiler Class allows the creation of rhythm snippets and compiles them into a rhythm string.
These snippets capture the repetitive aspects of most rhythms.

**3. countBase** is the rhythmical length that is assigned to one symbol in a string.
It is measured in quartenote lengths (relative to bpm), thus countBase: 1.0, means one quarter note per symbol. 

Classes
-------
The **RhythmCompiler** (class) generates rhythm snippets and combines these into rhythm strings.
These can be parsed to MIDI ready data by the **RhythmParser** (class).
The parsed output can be written to a MIDI file by the **MidiWriter** (class instance). 

Examples and Docs
-----------------

Check out the examples provided and the documentation based on YARD. The examples are aimed at 
creating single and multi instrument rhythms. For instance **Meshuggah_example.rb** explains the creation of the
intro rhythm of 'Perpetual Black Second' by Meshuggah (Nothing, 2002), using ruby scripting.


**minimal example**

In the example below we have skipped the creation of the rhythm string. 
A predefined rhythm is written to midi.

    require 'rhythmruby'
    
    midiNote = 50 # midi note assigned to drum hits
    bpm = 120 # beats per minute of midi file
    fileName = 'testing.midi' # name of midi file
    
    countBase = 1.0/4.0 # one symbol represents a sixteenth note (one fourth of a quarter note)
        
    rhythm = '#---#---' # two quarter note drum hits, on sixteenth note base
    
    # parse the rhythm string to MIDI ready information (array of [midiNote, noteLength] sub-arrays)
    midiInfo = RhythmParser.parseRhythm(rhythm, countBase, midiNote)
    
    midiWriter = MidiWriter.new(bpm) # midiWriter instance administrating one MIDI song
    midiTrack = midiWriter.createTrack() # create track in the MIDI song
    midiWriter.writeSeqToTrack(midiInfo, midiTrack) # write the parsed rhythm to a MIDI track
    midiWriter.writeToFile(fileName) # write MIDI song to file

Workflow on Linux
--------

On linux the MIDI files created with rhythmruby can be played from the command-line by programs like
pmidi. pmidi can send the MIDI events to any ALSA channel f.i. the MIDI-in of the Hydrogen sampler, which
is a nice drum sampler and sequencer. In this way you can listen to the rhythms you create without leaving your
IDE or editor.

Rational
--------

RhythmRuby's strength lies in the rhythm string abstraction. It allows easy computer
manipulation of rhythm snippets to create rhythm patterns. These can then be
written to a midi file, possibly consisting of several tracks (f.i. hihat, snare, kick)

With RhythmRuby you can capture polyrhythmics at their essence by creating patterns of rhythm snippets.
The resulting MIDI files are perfect for further use in DAW's such as (cubase, logic, etc.)

RhythmRuby was made to create drum rhythms for my band Hologram Earth (www.hologramearth.nl)

Acknowledgment
--------------
thanks Jim Menard for **midilib**, a pure ruby MIDI library.
https://github.com/jimm/midilib
