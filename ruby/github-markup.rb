require 'github/markup'
require 'time'
require 'json'
require 'digest/md5'

file = 'markdown/resume.md'
out = 'html/resume.html'
manifest = 'manifest.json'

newhash = Digest::MD5.hexdigest(File.read(file))
oldhash = JSON.parse(File.read(manifest))['resume']

if newhash == oldhash
    exit
end

File.open(out, 'w') do |output|
    output.puts '<head><meta name="viewport" content="width=device-width, initial-scale=1"></head>'
    output.puts '<body class="markdown-body">'
    output.puts GitHub::Markup.render(file, File.read(file))
    output.puts "<small style='float:right'>updated #{Time.now.utc.iso8601}</small>"
    output.puts '<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script></body>'
end

File.open(manifest, 'w') do |output|
    output.puts JSON.pretty_generate({'resume' => newhash})
end
