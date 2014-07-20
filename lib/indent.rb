module Indent
  def indent
    @spaces << '  '
  end

  def apply_indent(str)
    str.gsub(/^/, @spaces)
  end
end
