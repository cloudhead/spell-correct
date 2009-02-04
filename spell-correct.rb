#
# A Ruby Spell Corrector in 19 sloc. Based on Peter Norvig's python spell corrector
# 
LETTERS = ("a".."z").to_a
NWORDS = Hash.new( 1 )
File.new('holmes.txt').read.downcase.scan(/[a-z]+/) { |k| NWORDS[k] += 1 }

def edit word
    n = word.length
  
    (result = (0...n).collect { |i| word[0...i] + word[i + 1..-1] } +                                                      # Deletion
    (0...n-1).collect { |i| word[0...i] + word[i + 1, 1] + word[i, 1] + word[i + 2..-1] } +                                # Transposition    
    (n).times.collect { |i| LETTERS.collect { |l| word[0...i] + l.chr + word[i + 1..-1] } }.flatten +                      # Alteration
    (n + 1).times.collect { |i| LETTERS.collect { |l| word[0...i] + l.chr + word[i..-1] } }.flatten).empty? ? nil : result # Insertion  
end

def edit2 word
    edit( word ).collect { |e| known( edit( e ) ) }.reject { |v| !v }
end

def known words
    ( result = words.select { |w| NWORDS.has_key?(w) } ).empty? ? nil : result
end

def correct word
    ( known([word]) || known(edit(word)) || edit2(word) || word ).uniq.max do |a, b| NWORDS[a] <=> NWORDS[b] end
end