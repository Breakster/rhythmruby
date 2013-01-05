# RhythmRuby by Luuk van der Velden (Amsterdam, 2013)

RhythmRuby provides ruby and midi based rhythm delight. I made it 
to create drum patterns for my band Hologram Earth (www.hologramearth.nl).
Hope you enjoy it!

a rhythm string is a string consisting of two symbols one for silence (default '-'),
and one for an event or hit (default '#'). Thus two quarternotes on a sixteenth note raster
would look like this: '#---#---'. RubyRhythm allows for the creation, parsing and 
writing to midi of these rhythm strings.

it's strength is in the rhythm String abstraction. It allows easy computer
manipulation of rhythm snippets to create rhythm patterns. These can then be
written to a midi file consisting of several tracks (f.i. hihat, snare, kick)

With RhythmRuby you can capture polyrhythmics at their essence by scripting and
create midi drum tracks for further use in DAW's such as (cubase, logic, etc.)
