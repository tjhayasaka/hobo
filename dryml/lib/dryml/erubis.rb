module Dryml
  class Erubis < ::Erubis::Eruby
    #this is stolen pretty much unchanged from Rails3's ERB
    #they could use ours be we can't use theirs

    #modified to use rails_xss's version instead
    

    def add_text(src, text)
      src << "output_buffer << ('" << escape_text(text) << "'.html_safe!);"
    end
    
    def add_expr_literal(src, code)
      src << 'output_buffer << ((' << code << ').to_s);'
    end

    def add_expr_escaped(src, code)
      src << 'output_buffer << ' << escaped_expr(code) << ';'
    end

  end
      
end
