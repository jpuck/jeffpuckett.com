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
oldhash = resume['hash']

if newhash == oldhash
    puts 'same resume markdown, skipping html build'
    exit
end

data = {
    'resume' => {
        'time' => time,
        'hash' => newhash,
        'file' => "Puckett-Jeff.#{time}.pdf",
    },
}

puts 'building html from markdown resume'
File.open(out, 'w') do |output|
    output.puts '<head><meta name="viewport" content="width=device-width, initial-scale=1"></head>' +
        '<body class="markdown-body">' +
        GitHub::Markup.render(file, File.read(file)) +
        "<small style='float:right'>updated #{time}</small>" +
        '<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>' +
        '<script>$(\'body\').prepend(\'<input style="float:right" type="button" onclick="location.href=&quot;./' +
        data['resume']['file'] +
        '&quot;" value="Download PDF" />' +
        '\')</script></body>'
end

File.open(manifest, 'w') do |output|
    output.puts JSON.pretty_generate(data)
end
