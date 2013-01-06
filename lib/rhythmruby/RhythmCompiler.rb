
# rhythm composition class (use as a class)
# compiles rhythm snippets into a rhythm string/pattern
class RhythmCompiler
  @@silenceMarker = '-' # symbol for silence
  @@eventMarker = '#' # symbol for an event / hit
  
  # create an array of snippets of length in snippetLengths,
  # with events at position(s) in eventPositions
  # @param [Array<Fixnum>] snippetLengths length of each snippet
  #   (if snippetLengths.length == 1, length is constant for all snippets )
  # @param [Array<Array>] eventPositions containing arrays of event positions per snippet 
  #   (if eventPositions.length == 1, then event positions are constant for all snippets)
  # @return [Array<String>] snippets array of string rhythm snippets,
  #   for use with 'createString' method  
  def self.createSnippets(snippetLengths, eventPositions)
    snippets = [] # empty array to append the snippets
    
    # make input arrays suitable for fur
    if snippetLengths.length == 1
      # make snippetLengths as long as eventPositions      
      snippetLengths *= eventPositions.length 
             
    elsif eventPositions.length == 1 
     # make eventPositions as long as snippetLengths 
     eventPositions *= snippetLengths.length 
     
    else # both input arrays have more than one element and should be the same length
      if not(eventPositions.length == snippetLengths.length)
        raise ArgumentError, 'lengths of both arrays should be the same, \
         or one should have length 1'
      end
    end    
    
    #create a rhythm snippet for each set of event positions and snippetlength
    snippetLengths.zip(eventPositions).each do  
        |length, positions| # unpack the length and position information   
        # create a snippet of defined length consisting of silences
        snippet = @@silenceMarker*length 
                
        positions.each{|pos| # for each provided event positon of the snippet
          snippet[pos] = @@eventMarker # add an event marker at the position
        }
        
        snippets<<snippet # add the snippet to the returned snippets array
     end   
     return snippets # return the array with the snippets
  end
  
  
  # creates a rhythm string from rhythm snippets
  # @param [Array<String>] snippets array of rhythm snippets (from 'createSnippets)
  # @param [Array<Fixnum>] snippetIDx indexes, defining sequential order of snippets
  # @param [Array<Fixnum>] nRepeats defining how often snippets are repeated...
  #   if nil, all snippets are repeated once, if nRepeats.length==1, all snippets are repeated the same amount
  #   otherwise nRepeats should be the same length as snippetIdx and define repetition per snippet
  def self.createRhythm(snippets, snippetIDx, nRepeats)
    if nRepeats == nil # test whether nRepeats is defined, if not all snippets are repeated once
      nRepeats = [1]*snippetIDx.length # make nRepeats and snippetIDx the same length for iteration
    end 
    
    rhythmString = "" # empty string where all the snippets will be added to
    
    # iterate over combinations of snippetID and repeats
    snippetIDx.zip(nRepeats).each do
      |snippetID, repeats|
      # add the snippet with snippetID, repeat times, to the rhythm string 
      rhythmString += snippets[snippetID]*repeats 
    end
    
    return rhythmString # return the rhythm string ready for parsing
  end
end
