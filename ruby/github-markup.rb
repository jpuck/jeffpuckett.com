require 'github/markup'
require 'time'
require 'json'
require 'digest/md5'

file = 'markdown/cv.md'
out = 'html/cv.html'
manifest = 'manifest.json'

time = Time.now.utc.iso8601
cv = JSON.parse(File.read(manifest))['cv']

newhash = Digest::MD5.hexdigest(File.read(file))
oldhash = cv['hash']

if newhash == oldhash
    puts 'same cv markdown, skipping html build'
    exit
end

data = {
    'cv' => {
        'time' => time,
        'hash' => newhash,
        'file' => "Puckett-Jeff.#{time}.pdf",
    },
}

puts 'building html from markdown cv'
File.open(out, 'w') do |output|
    output.puts '
    <!DOCTYPE html>
    <html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
    </head>
    <body class="markdown-body">' +
        GitHub::Markup.render(file, File.read(file)) +
        "<small style='float:right'>updated #{time}</small><br>" +
        '<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script>
        $("body").append(\'<button style="float:right" onclick="window.open(&quot;./' + data['cv']['file'] + '&quot;)">Download PDF</button>\')
        </script>
    </body>
    </html>'
end

File.open(manifest, 'w') do |output|
    output.puts JSON.pretty_generate(data)
end
