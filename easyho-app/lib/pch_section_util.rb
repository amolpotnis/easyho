class Pch_section_util
     
  def initialize
    @displayorder = -1
    @sec_id = -1
    @displayname = "test"
  end
  
  def getDisplayOrder
    @displayorder
  end
  def setDisplayOrder(order)
      @displayorder = order
  end
  
  def getSectionId
    @sec_id
  end
  def setSectionId(givenId)
    @sec_id = givenId
  end
  
  def getDisplayName
    @displayname
  end
  def setDisplayName(givenName)
    @displayname = givenName
  end
  
end