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
        <title>Jeff Puckett r&eacute;sum&eacute; / curriculum vitae</title>
        <meta name="description" content="Jeff Puckett\'s r&eacute;sum&eacute; / curriculum vitae. He is a programmer and instructor at the University of Arkansas.">
        <meta name="author" content="Jeff Puckett">
        <link rel="icon" href="/favicon.ico">
        <meta property="og:title" content="Jeff Puckett" />
        <meta property="og:description" content="Jeff Puckett\'s r&eacute;sum&eacute; / curriculum vitae. He is a programmer and instructor at the University of Arkansas." />
        <meta property="og:type" content="profile" />
        <meta property="og:url" content="https://jeffpuckett.com" />
        <meta property="og:image" content="https://jeffpuckett.com/images/jeff-puckett.gsm.jpg" />
        <meta name="twitter:card" content="summary" />
        <meta name="twitter:site" content="@_jpuck" />
        <meta name="twitter:creator" content="@_jpuck" />
        <meta name="twitter:image:alt" content="A profile picture of Jeff Puckett." />
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
