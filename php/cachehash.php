<?php

$assets = [
    './docs/js/jp.main.js',
    './docs/css/jp.main.css',
    './docs/css/jp.cv.css',
];

foreach (rglob('./docs/*.html') as $page) {
    $pages []= $page;
}

foreach ($assets as $asset) {
    $hash = hash_file('md5', $asset);
    $info = pathinfo($asset);
    $file = "$info[dirname]/$info[filename].$hash.$info[extension]";
    rename($asset, $file);

    foreach ($pages as $page) {
        // https://stackoverflow.com/a/11901576/4233593
        $content = file_get_contents($page);
        $content = str_replace(basename($asset), basename($file), $content);
        file_put_contents($page, $content);
    }
}

// https://stackoverflow.com/a/17161106/4233593
function rglob($pattern, $flags = 0) {
    $files = glob($pattern, $flags); 
    foreach (glob(dirname($pattern).'/*', GLOB_ONLYDIR|GLOB_NOSORT) as $dir) {
        $files = array_merge($files, rglob($dir.'/'.basename($pattern), $flags));
    }
    return $files;
}
