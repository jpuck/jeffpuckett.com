require 'github/markup'
require 'time'
require 'json'
require 'digest/md5'

file = 'markdown/resume.md'
out = 'html/resume.html'
manifest = 'manifest.json'

time = Time.now.utc.iso8601
resume = JSON.parse(File.read(manifest))['resume']

newhash = Digest::MD5.hexdigest(File.read(file))
oldhash = resume.values.first

if newhash == oldhash
    exit
end

File.open(out, 'w') do |output|
    output.puts '<head><meta name="viewport" content="width=device-width, initial-scale=1"></head>'
    output.puts '<body class="markdown-body">'
    output.puts GitHub::Markup.render(file, File.read(file))
    output.puts "<small style='float:right'>updated #{time}</small>"
    output.puts '<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script></body>'
end

File.open(manifest, 'w') do |output|
    output.puts JSON.pretty_generate({'resume' => {time => newhash}})
end
