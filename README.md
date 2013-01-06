RhythmRuby: Midi rhythms through string manipulation 
====================================================

**Homepage**:this
**Author**: Luuk van der Velden, (Amsterdam, 2013)

Synopsis
--------

RhythmRuby provides the creation of midi rhythms, through string manipulation. 
It provides methods for rhythm/string creation, parsing and writing the rhythms
to midi tracks. ruby and midi based rhythm delight! I made it to create 
drum patterns for my band Hologram Earth (www.hologramearth.nl). Hope you enjoy it!

Basics
------

**1.  **rhythm string** is a string consisting of two symbols.
One for silence (default '-') and one for an event or hit (default '#').
Thus the rhythm string of two quarternotes on a sixteenth note raster look like this:
'#---#---'. 

**2. **countBase** is the rhythmical length that is assigned to a symbol in a string.
it is measured in quartenote lengths (relative to bpm). So countBase: 1.0/4.0 means one fourth
of a quarternote, thus 1 sixteenth note, which means every symbol is interpreted as a sixteenth note. 

**3. a rhythm string is made up out of rhythm snippets, or short strings. with the
StringCompiler these snippets can be created and compiled into a rhythm string.
These snippets capture the repetitative aspects of most rhythms.

Rational
--------

RhythmRuby's strength is in the rhythm string abstraction. It allows easy computer
manipulation of rhythm snippets to create rhythm patterns. These can then be
written to a midi file, consisting of several tracks (f.i. hihat, snare, kick)

With RhythmRuby you can capture polyrhythmics at their essence by scripting and
create midi drum tracks for further use in DAW's such as (cubase, logic, etc.)
