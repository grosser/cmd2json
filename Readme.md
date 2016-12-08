Covert command output and exit status to json to pipe them atomically into logs

Install
=======

```Bash
gem install cmd2json
```

Usage
=====

```Ruby
cmd2json -a 'foo=bar' echo hello | logger -t test
tail -1 /var/log/user.log
2016-12-08T00:34:17+00:00 app1.hostfoo.com test: {"timestamp":"2016-12-08 00:34:17 +0000", "message":"hello", "exit":"0", "foo":"bar"}
```

TODO
====
 - `--tee` option that still streams stdout and stderr
 - stdin support

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/cmd2_json.png)](https://travis-ci.org/grosser/cmd2_json)
