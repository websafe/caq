Installation
--------------------------------------------------------------------------------

### General installation procedure

Only `caq.sh`(https://raw.github.com/websafe/caq/master/caq.sh) is really
required, download it into a location available via PATH and make it executable.
That's all.


### Install using wget

~~~~
wget -nc \
    https://raw.github.com/websafe/caq/master/caq.sh \
    -O /usr/bin/caq
chmod +x /usr/bin/caq
~~~~


`-ns` stands for `--no-clobber`:

>  -nc, --no-clobber              skip downloads that would download to
>                                 existing files (overwriting them).


### Install using lynx

~~~~
lynx -dump \
    https://raw.github.com/websafe/caq/master/caq.sh \
    > /usr/bin/caq
chmod +x /usr/bin/caq
~~~~


