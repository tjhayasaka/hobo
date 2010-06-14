module Dryml
  class Erubis < ::Erubis::Eruby
    #this is stolen pretty much unchanged from Rails3's ERB
    #they could use ours be we can't use theirs

    #modified to use rails_xss's version instead
    

    def add_text(src, text)
      src << "output_buffer << ('" << escape_text(text) << "'.html_safe);" unless text.empty?
    end
    
    def add_expr_literal(src, code)
      unless code.empty?
        if code =~ /\s*raw\s+(.*)/m
          src << "output_buffer << ((" << $1 << ").to_s.html_safe);"
        else
          src << 'output_buffer << ((' << code << ').to_s);' unless code.empty?
        end
      end
    end

    def add_expr_escaped(src, code)
      src << 'output_buffer << ' << escaped_expr(code) << ';' unless code.empty?
    end

  end
      
end
