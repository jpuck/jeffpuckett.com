require 'github/markup'

file = 'markdown/resume.md'
out = 'docs/resume.html'

File.open(out, 'w') do |output|
  output.puts GitHub::Markup.render(file, File.read(file))
end
