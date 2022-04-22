## 4/17/2022

Currently working on the emulator. I just did some experimentation and found
that reads and writes each take a cycle. I'm now wondering if maybe I should be
using micro-operations that either complete in one cycle or block.

For example,

```
mov left right
```

would be translated to

```
read left
write right
```

This seems natural except that `mov 3 right` is not naturally decomposable into
two micro-operations taking one cycle each. This whole instruction should take
exactly one cycle. Maybe not microinstructions, then?

How are we going to implement "ANY"? For each port, we need to be able to tell
if it's readable and if it's writable on any particular cycle. I think we really
need to figure out what our I/O is going to look like within the emulator in
order to design this interface.

I'm thinking a named pipe might be a good way to make this work.
