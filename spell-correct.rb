NWORDS = Hash.new( 1 )

File.new('holmes.txt').read.downcase.scan(/[a-z]+/) { |k| NWORDS[k] += 1 }

LETTERS = ("a".."z").to_a.join

def edit word
    n = word.length
    alteration = insertion = []
  
    deletion = (0...n).collect do |i| word[0...i] + word[i + 1..-1] end                                          # Deletion
    transposition = (0...n-1).collect do |i| word[0...i] + word[i + 1, 1] + word[i, 1] + word[i + 2..-1] end     # Transposition
    n.times do |i| LETTERS.each_byte do |l| alteration << word[0...i] + l.chr + word[i + 1..-1] end end          # Alterations
    (n + 1).times do |i| LETTERS.each_byte do |l| insertion << word[0...i] + l.chr + word[i..-1] end end         # Insertion
  
    if ! ( result = deletion + transposition + alteration + insertion ).empty? then result end
end

def edit2 word
    edit( word ).collect do |e| known( edit( e ) ) end.reject do |v| !v end
end

def known words
    if ! ( result = words.select do |w| NWORDS.has_key?(w) end ).empty? then result end
end

def correct word
    ( known([word]) || known(edit(word)) || edit2(word) || word ).first.max do |a, b| 
        NWORDS[a] <=> NWORDS[b] end || nil
end