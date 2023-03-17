#!/usr/bin/env bash
set -euxo pipefail

mkdir -p html/mspm0l
python3 scripts/htmlcomparesvd.py html/mspm0l svd/mspm0l{110x,130x,134x}.svd.patched
sed -i 's#<table>#<p>Only a representative member of each family included; click to view entire family</p><table>#' html/mspm0l/index.html
sed -i 's#mspm0l110x#<a href="mspm0l/index.html">MSPM0L110X</a>#' html/mspm0l/index.html
sed -i 's#mspm0l110x#<a href="mspm0l/index.html">MSPM0L130X</a>#' html/mspm0l/index.html
sed -i 's#mspm0l110x#<a href="mspm0l/index.html">MSPM0L134X</a>#' html/mspm0l/index.html

mkdir -p html/mspm0g
python3 scripts/htmlcomparesvd.py html/mspm0g svd/mspm0g{110x,150x,310x,350x}.svd.patched
sed -i 's#<table>#<p>Only a representative member of each family included; click to view entire family</p><table>#' html/mspm0l/index.html
sed -i 's#mspm0g110x#<a href="mspm0l/index.html">MSPM0G110X</a>#' html/mspm0l/index.html
sed -i 's#mspm0g150x#<a href="mspm0l/index.html">MSPM0G150X</a>#' html/mspm0l/index.html
sed -i 's#mspm0g310x#<a href="mspm0l/index.html">MSPM0G310X</a>#' html/mspm0l/index.html
sed -i 's#mspm0g350x#<a href="mspm0l/index.html">MSPM0G350X</a>#' html/mspm0l/index.html


cat > html/comparisons.html <<EOF
<!DOCTYPE html>
<head>
<meta charset="utf-8">
<meta name=viewport content="width=device-width, initial-scale=1">
<title>mspm0 Peripheral Comparisons</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
</head>

<body>
<nav class="navbar navbar-inverse">
  <div class="container">
    <div class="navbar-header">
      <a class="navbar-brand" href="index.html">stm32-rs Device Coverage</a>
    </div>
    <div class="navbar-collapse collapse">
      <ul class="nav navbar-nav">
        <li class="active"><a href="#">Peripheral Comparisons</a></li>
      </ul>
    </div>
  </div>
</nav>

<h1>Device families</h1>
<ul>
  <li><a href="mspm0l/index.html">MSPM0L</a></li>
  <li><a href="mspm0g/index.html">MSPM0G</a></li>
</ul>
</body>
</html>
EOF
