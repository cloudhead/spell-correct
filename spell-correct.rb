#
# A Ruby Spell Corrector in 19 sloc. Based on Peter Norvig's python spell corrector
#
LETTERS = ("a".."z").to_a
NWORDS = Hash.new(1)
File.new('holmes.txt').read.downcase.scan(/[a-z]+/) {|k| NWORDS[k] += 1 }

def edit word
  n = word.length

  (0...n).map       {|i| word[0...i] + word[i + 1..-1] } +                                      # Deletion
  (0...n-1).map     {|i| word[0...i] + word[i + 1, 1] + word[i, 1] + word[i + 2..-1] } +        # Transposition
  (n).times.map     {|i| LETTERS.map {|l| word[0...i] + l.chr + word[i + 1..-1] } }.flatten +   # Alteration
  (n + 1).times.map {|i| LETTERS.map {|l| word[0...i] + l.chr + word[i..-1] } }.flatten         # Insertion
end

def edit2 word
  edit(word).map {|e| known edit(e) }.compact
end

def known words
  words.select {|w| NWORDS.has_key? w }
end

def correct word
  [known([word]), known(edit(word)), edit2(word), word].reject {|i| i.empty? }.first.uniq.max {|a, b| NWORDS[a] <=> NWORDS[b] }
end
