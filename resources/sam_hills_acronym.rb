class SamHillsAcronym

  def self.choose(selector='')
    acronyms.select { |acronym| acronym =~ /#{selector}/i }.sample
  end

  def self.acronyms
    @acronyms ||= [
      "CD-ROM: Consumer Device, Rendered Obsolete in Months",
      "PCMCIA: People Can't Memorize Computer Industry Acronyms",
      "ISDN: It Still Does Nothing",
      "SCSI: System Can't See It",
      "MIPS: Meaningless Indication of Processor Speed",
      "DOS: Defunct Operating System",
      "WINDOWS: Will Install Needless Data On Whole System",
      "OS/2: Obsolete Soon, Too",
      "PnP: Plug and Pray",
      "APPLE: Arrogance Produces Profit-Losing Entity",
      "IBM: I Blame Microsoft",
      "DEC: Do Expect Cuts",
      "MICROSOFT: Most Intelligent Customers Realize Our Software Only Fools Teenagers",
      "CA: Constant Acquisitions",
      "COBOL: Completely Obsolete Business Oriented Language",
      "LISP: Lots of Insipid and Stupid Parentheses",
      "MACINTOSH: Most Applications Crash; If Not, The Operating System Hangs",
      "AAAAA: American Association Against Acronym Abuse.",
      "WYSIWYMGIYRRLAAGW: What You See Is What You Might Get If You're Really Really Lucky And All Goes Well." 
    ]
  end
end
