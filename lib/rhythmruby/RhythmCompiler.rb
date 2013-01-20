
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
  # @param [Array<Fixnum>] snippetRep defining how often snippets are repeated...
  #   if nil, all snippets are repeated once, if snippetRep.length==1, all snippets are repeated the same amount
  #   otherwise snippetRep should be the same length as snippetIdx and define repetition per snippet
  # @param [Fixnum] totalRepeat, number of times the total rhythm is repeated
  # @return [String] rhythmString, symbolic rhythm string
  def self.createRhythm(snippets, snippetIDx, snippetRep, totalRepeat)
    if snippetRep == nil # test whether snippetRep is defined, if not all snippets are repeated once
      snippetRep = [1]*snippetIDx.length # make snippetRep and snippetIDx the same length for iteration
    end 
    if totalRepeat == nil # if undefined set repeats equal to 1
      totalRepeat = 1
    end
    
    
    rhythmString = "" # empty string where all the snippets will be added to
    
    # iterate over combinations of snippetID and repeats
    snippetIDx.zip(snippetRep).each do
      |snippetID, repeats|
      # add the snippet with snippetID, repeat times, to the rhythm string 
      rhythmString += snippets[snippetID]*repeats 
    end
    
    return rhythmString*totalRepeat # return the rhythm string repeated totalRepeat times, ready for parsing
  end
  
  # logical exlusion of two rhythms, removes events from slave simultaneous withn an event in master
  # @param [String] masterRhythm rhythm to intersect with
  # @param [String] slaveRhythm rhythm to intersect
  # @return [String] intersected slaveRhythm
  def self.Exclusion(masterRhythm, slaveRhythm)
    masterRhythm.split("").zip(slaveRhythm.split("")).each_with_index do
      |symbols, index|
      master,slave = symbols
      if master == @@eventMarker && slave == @@eventMarker # if both have an event
        slaveRhythm[index] = @@silenceMarker # replace event with silence
      end
    end
    return slaveRhythm
  end  
  
  # logical or of two rhythms, thus event in result rhythm, when at least one
  # of two original rhythms has an event
  # @param [String] rhythmA, one of the rhythms to or
  # @param [String] rhythmB, one of the rhythms to or
  # @return [String] resultRhyhtm, result of logical or 
  def self.Logical_Or(rhythmA, rhyhtmB)
    resultRhythm = ""
        
    rhythmA.split("").zip(rhythmB.split("")).each do
      |symA, symB|
      if symA == @@eventMarker or symB == @@eventMarker
        resultRhythm += @@eventMaker
      else
        resultRhythm += @@silenceMarker
      end
    end
    
    return resultRhythm    
  end
  
end
