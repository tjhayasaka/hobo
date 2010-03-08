module Dryml
  XssMods = classy_module do
    def erb_process_with_xss(erb_src, method_def=false)
      trim_mode = ActionView::TemplateHandlers::ERB.erb_trim_mode
      src = Dryml::Erubis.new(erb_src, :trim => (trim_mode=='-'), :preamble => false, :postamble => false).src
      
      if method_def
        src.sub /^\s*def.*?\(.*?\)/, '\0 __in_erb_template=true; '
      else
        "__in_erb_template=true; " + src
      end
    end
    alias_method_chain :erb_process, :xss
  end
end
