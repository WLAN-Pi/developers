# Anti-patterns

An [anti-pattern](http://en.wikipedia.org/wiki/Anti-pattern) is a common response to a recurring problem that is usually ineffective and risks being highly counterproductive.

__We should always strive against creating antipatterns in our code.__

## Global Variables

Do not use `global foobar` in Python. Instead use the Global Object Pattern.

### Read More

* [The Global Object Pattern](https://python-patterns.guide/python/module-globals/)
* [How do I share global variables across modules?](https://docs.python.org/3/faq/programming.html#how-do-i-share-global-variables-across-modules)
* [How to avoid using global variables?](https://stackoverflow.com/a/59330720)

## File Extensions

### Use an extension that matches the contents

Here is an example where the extension and filename misleads the reader to assume the file contents follow a packet capture format, however, the contents are instead an ASCII dump and the file is not readable by Wireshark.

```bash
wlanpi@wlanpi:/tmp $ file lldpneightcpdump.cap
lldpneightcpdump.cap: ASCII text
```

__What's wrong with this?__ The file extension is misleading.

The better file extension in this example would be `.txt` or similar rather than `.cap`. It better represents the contents.

A file with extension `.cap` should have contents similar to this:

```bash
wlanpi@wlanpi:~ $ file test.cap
test.cap: pcap capture file, microsecond ts (little-endian) - version 2.4 (Ethernet, capture length 262144)
```

### Read More

- [Bash: Why is testing "$?" to see if a command succeeded or not, an anti-pattern?](https://stackoverflow.com/questions/36313216/why-is-testing-to-see-if-a-command-succeeded-or-not-an-anti-pattern)
- [Python Anti-Patterns](https://docs.quantifiedcode.com/python-anti-patterns/)
- [18 Common Python Anti-Patterns I Wish I Had Known Before](https://towardsdatascience.com/18-common-python-anti-patterns-i-wish-i-had-known-before-44d983805f0f)