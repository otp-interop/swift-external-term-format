# External Term Format

> [!NOTE]
> This package requires Swift 6.2+ for its `Span` type.
> When running on macOS on an OS older than 26.0, make sure to set the `DYLD_LIBRARY_PATH`:
> ```
> swiftly run swift build
> DYLD_LIBRARY_PATH="/Library/Developer/Toolchains/swift-6.2-DEVELOPMENT-SNAPSHOT-2025-06-14-a.xctoolchain/usr/lib/swift/macosx" \
> .build/arm64-apple-macosx/debug/ExternalTermFormatBenchmarks
> ```

Encoding/decoding for Erlang's [External Term Format](https://www.erlang.org/doc/apps/erts/erl_ext_dist.html).
Compatible with Embedded Swift.

The entire package is built on the `Term` enum, which reflects all possible encoded values in Erlang's external term format.


```
let greeting = Term.atom("Hello, world!")
greeting.encoded() // [131, ]

let decoded = Term(parsing: [131, ])
```