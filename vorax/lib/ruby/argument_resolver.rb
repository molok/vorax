require 'stringio'

class ArgumentResolver

  def self.arguments_for(stmt, cpos)
    puts "stmt=#{stmt.inspect} cpos=#{cpos}"
    input = ANTLR3::StringStream.new(stmt.upcase)
    lexer = Argument::Lexer.new(input)
    lexer.map
    lexer.pmodules.each do |m|
      p m
      m[:args].each do |a|
        p a
        if a.pos.include?(cpos) && a.expr.nil?
          return m[:name]
        elsif a.pos.include?(cpos) && !a.expr.nil?
          return ArgumentResolver.arguments_for(a.expr.gsub(/^\(|\)$/, ' '), cpos - a.pos.first)
        end
      end
    end
    nil
  end

end
