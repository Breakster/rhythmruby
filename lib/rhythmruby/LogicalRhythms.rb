class LogicalRhythms
  @@eventMarker = '#' # symbol which denotes event or hit
  @@silenceMarker = '-' # symbol that denotes silence
  
  # logical exlusion of two rhythms, removes events from slave simultaneous
  # with an event in the master rhythm
  # @param [String] masterRhythm rhythm to intersect with
  # @param [String] slaveRhythm rhythm to intersect
  # @return [String] intersected slaveRhythm
  def self.Exlusion(masterRhythm, slaveRhythm)
    masterRhythm.split("").zip(slaveRhythm.split("")).each_with_index do
      |symbols, index|
      master,slave = symbols
      if master == @@eventMarker && slave == @@eventMarker # if both have an event
        slaveRhythm[index] = @@silenceMarker # replace event with silence
      end
    end
    return slaveRhythm
  end  

  # logical XOR of two rhythms, true except both true
  # @param [String] masterRhythm rhythm to intersect with
  # @param [String] slaveRhythm rhythm to intersect
  # @return [String] intersected slaveRhythm
  def self.Xor(rhythmA, rhythmB)
    resultRhythm = ""
    rhythmA.split("").zip(rhythmB.split("")).each do
      |symA, symB|
      if symA == @@eventMarker && symB == @@eventMarker # if both have an event
        resultRhythm += @@silenceMarker # replace event with silence
      elsif symA == @@eventMarker or symB == @@eventMarker
        resultRhythm += @@eventMarker
      else
        resultRhythm += @@silenceMarker
      end
    end
    return slaveRhythm
  end  
  
  # logical OR of two rhythms, thus event in result rhythm, when at least one
  # of two original rhythms has an event (functionally the same as addition)
  # @param [String] rhythmA, one of the rhythms to or
  # @param [String] rhythmB, one of the rhythms to or
  # @return [String] resultRhyhtm, result of logical or 
  def self.Or(rhythmA, rhyhtmB)
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
  
  #  logical AND of two rhythms, returns only events present in both rhythms
  # @param [String] rhythmA, one of the rhythms to and
  # @param [String] rhythmB, one of the rhythms to and
  # @return [String] resultRhythm, result of logical and
  def self.And(rhythmA, rhythmB)
    resultRhythm = ""
    rhythmA.split("").zip(rhythmB.split("")).each do
      |symA, symB|
      if symA == @@eventMarker and symb == @@eventMarker
        resultRhythm += @@eventMarker
       else
         resultRhythm += @@silenceMarker       
      end
    end
    return resultRhythm
  end
 
end