<?php

$pages = [
    'docs/index.html' => 'https://jeffpuckett.com/',
    'docs/cv/index.html' => 'https://jeffpuckett.com/cv/',
    'docs/gpg/index.html' => 'https://jeffpuckett.com/gpg/',
];

$sitemap = realpath(__DIR__.'/../docs/sitemap.xml');

require_once __DIR__.'/../vendor/autoload.php';

$repo = Git::open(dirname(__DIR__));

$modified = explode(PHP_EOL, trim($repo->run('ls-files --modified')));

foreach ($modified as $file) {
    if (isset($pages[$file])) {
        $news[$file] = $pages[$file];
    }
}

if (empty($news)) {
    die("no modified timestamps for sitemap\n");
}

$xml = new DOMDocument('1.0', 'utf-8');
$xml->formatOutput = true;
$xml->preserveWhiteSpace = true;
$xml->load($sitemap);

foreach ($xml->getElementsByTagName('url') as $url) {
    $location = $url->getElementsByTagName('loc')->item(0);
    if (in_array($location->nodeValue, $news)) {
        $url->getElementsByTagName('lastmod')->item(0)->nodeValue = date('c');
    }
}

$xml->save($sitemap);
