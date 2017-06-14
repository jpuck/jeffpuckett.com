require 'github/markup'

file = 'markdown/resume.md'
out = 'html/resume.html'

File.open(out, 'w') do |output|
    output.puts '<head><meta name="viewport" content="width=device-width, initial-scale=1"></head>'
    output.puts '<body class="markdown-body">'
    output.puts GitHub::Markup.render(file, File.read(file))
    output.puts '<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script></body>'
end
