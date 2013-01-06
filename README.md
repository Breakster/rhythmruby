RhythmRuby: Midi rhythms through string manipulation 
====================================================

**Author**: Luuk van der Velden, (Amsterdam, 2013)

Synopsis
--------

RhythmRuby enables the creation of midi rhythms, through string manipulation. 
It provides methods for rhythm/string creation, parsing and writing them to midi tracks.
Ruby and MIDI based rhythm delight!

Basics
------

**1. rhythm string** is a string consisting of two symbols,
one for silence (default '-') and one for an event or hit (default '#'). An example:
'#---#---#---#---', is read as one (drum) hit every three silences. 

**2. rhythm snippets** are the building blocks of a rhythm string. With the
StringCompiler Class these snippets can be created and compiled into a rhythm string.
These snippets capture the repetitive aspects of most rhythms.

**3. countBase** is the rhythmical length that is assigned to one symbol in a string.
It is measured in quartenote lengths (relative to bpm), thus countBase: 1.0, means one quarternote per symbol. 

**installation:** gem install rhythmruby

Examples and Docs
-----
check out the examples provided and the documentation based on YARD. The examples are aimed at 
creating single and multi instrument rhythms.

Classes
-------
The **RhythmCompiler** (class) generates rhythm snippets and combines these into rhythm strings.
These can be parsed to MIDI ready data by the **RhythmParser** (class).
The parsed output can be written to a MIDI file by the **MidiWriter** (class instance). 

Rational
--------

RhythmRuby's strength lies in the rhythm string abstraction. It allows easy computer
manipulation of rhythm snippets to create rhythm patterns. These can then be
written to a midi file, possibly consisting of several tracks (f.i. hihat, snare, kick)

With RhythmRuby you can capture polyrhythmics at their essence by compiling rhythms out of
rhythm snippets and write them to midi drum tracks for further use in DAW's such as (cubase, logic, etc.)

I made it to create drum rhythms for my band Hologram Earth (www.hologramearth.nl)

Acknowledgment
--------------
thanks Jim Menard for **midilib**, a pure ruby MIDI library.
https://github.com/jimm/midilib
