# b3e

Fast Base62 encoding/decoding for Ruby strings.

```ruby
require "b3e"

B3e.encode("hello")
=> "vxGblhG"

B3e.decode("vxGblhG")
=> "hello"
```

## Rationale

Base62 creates url-safe, user-friendly strings from arbitrary bytes. It's similar to Base64 encoding, but restricted to
an alphanumeric alphabet. This means that Base62 strings contain no special characters and can be easily selected by a
user, making them ideal for things that a user will interact with—like api keys.

This library pulls inspiration from the [glowfall/base62](https://github.com/glowfall/base62) and
[jxskiss/base62](https://github.com/jxskiss/base62) projects to make encoding and decoding fast enough for nearly any
use case. Here's a benchmark for encoding 512 random bytes:

```
$ bundle exec ruby benchmarks/encode.rb

Warming up --------------------------------------
                 b3e    34.943k i/100ms
              base64    36.338k i/100ms
Calculating -------------------------------------
                 b3e    368.076k (± 3.7%) i/s -      1.852M in   5.038917s
              base64    355.178k (± 3.3%) i/s -      1.781M in   5.019292s

Comparison:
                 b3e:   368076.4 i/s
              base64:   355178.1 i/s - same-ish: difference falls within error
```

And here's a benchmark for decoding the encoded strings from above:

```
$ bundle exec ruby benchmarks/decode.rb

Warming up --------------------------------------
                 b3e    61.821k i/100ms
              base64    35.402k i/100ms
Calculating -------------------------------------
                 b3e    612.307k (± 4.5%) i/s -      3.091M in   5.058411s
              base64    312.973k (±11.0%) i/s -      1.558M in   5.040309s

Comparison:
                 b3e:   612306.9 i/s
              base64:   312973.3 i/s - 1.96x  (± 0.00) slower
```

Compared to Ruby's built-in Base64 encoder, `b3e` encodes at a similar rate but is actually *faster* at decoding.

## Tradeoffs

`b3e` is plenty fast, but it comes with a tradeoff. The encodings that `b3e` generates are less portable because it
uses a different algorithm than most other Base62 encoders. Here's a comparison between `b3e` and `b3bm` (a Base62
encoder that takes more of a standard tack):

```ruby
B3e.encode("hello")
=> "vxGblhG"

B3bm.encode("hello")
=> "7tQLFHz"
```

*What this means is that encodings generated with `b3e` might not decode correctly by Base62 libraries in other
ecosystems.* Base62 lacks a formally defined standard so there is already quite a bit of variability between
libraries, but keep this in mind if your encodings need to be consumed by other tools.

## Alternatives

Here's a couple other approaches in the Ruby ecosystem:

* [`b3bm`](https://github.com/metabahn/b3bm): Counterpart to `b3e`, but generates more portable encodings a lot more slowly.
* [`base62-rb`](https://github.com/steventen/base62-rb): Base62 encoder/decoder for integers, implemented in Ruby.
* [`yab62`](https://github.com/siong1987/yab62): Base62 encoder/decoder for integers, implemented in C.
