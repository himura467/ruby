# bench_speed_scaling
## master
ruby 4.1.0dev (2026-06-21T03:05:27Z master a2b9d6ff3b) +PRISM [arm64-darwin25]
parent: 20000000 bytes, offset: 1000000, N=10000

middle slice [1000000, 1000]                      4171882 ops/s
middle slice [1000000, 10000]                      405383 ops/s
middle slice [1000000, 100000]                     201066 ops/s
middle slice [1000000, 1000000]                     47318 ops/s
middle slice [1000000, 10000000]                     2262 ops/s
tail   slice [-10_000_000, 10_000_000] (control)   11273957 ops/s

## no-gc-terminator
ruby 4.1.0dev (2026-06-30T08:59:10Z no-gc-terminator c62340f23e) +PRISM [arm64-darwin25]
parent: 20000000 bytes, offset: 1000000, N=10000

middle slice [1000000, 1000]                      9699321 ops/s
middle slice [1000000, 10000]                    11086475 ops/s
middle slice [1000000, 100000]                   10917031 ops/s
middle slice [1000000, 1000000]                  11123471 ops/s
middle slice [1000000, 10000000]                 11402509 ops/s
tail   slice [-10_000_000, 10_000_000] (control)    8912656 ops/s

# bench_small_string_slice
## master
ruby 4.1.0dev (2026-06-21T03:05:27Z master a2b9d6ff3b) +PRISM [arm64-darwin25]
parent: 10000 bytes, N=100000
embed threshold: len <= 999 bytes (64-bit)

slice [0, 100] (embedded)                               7629511 ops/s
slice [0, 100] + == (embedded)                          9630200 ops/s
slice [0, 1000] (ELTS_SHARED)                           4791108 ops/s
slice [0, 1000] + == (ELTS_SHARED)                      4276245 ops/s
slice [0, 10000] (ELTS_SHARED)                          6807352 ops/s
slice [0, 10000] + == (ELTS_SHARED)                     9793360 ops/s

## no-gc-terminator
ruby 4.1.0dev (2026-06-30T08:59:10Z no-gc-terminator c62340f23e) +PRISM [arm64-darwin25]
parent: 10000 bytes, N=100000
embed threshold: len <= 999 bytes (64-bit)

slice [0, 100] (embedded)                               8798944 ops/s
slice [0, 100] + == (embedded)                         10751532 ops/s
slice [0, 1000] (ELTS_SHARED)                          10861301 ops/s
slice [0, 1000] + == (ELTS_SHARED)                      9753243 ops/s
slice [0, 10000] (ELTS_SHARED)                         11738467 ops/s
slice [0, 10000] + == (ELTS_SHARED)                     9678668 ops/s

# bench_memory_sharing_win
## master
ruby 4.1.0dev (2026-06-21T03:05:27Z master a2b9d6ff3b) +PRISM [arm64-darwin25]
parent: 10000000 bytes
slices: 1000 x 100000 bytes (naive copy total: 100MB)
heap_live_slots: 19807
        0.04 real         0.03 user         0.01 sys
           145063936  maximum resident set size
                   0  average shared memory size
                   0  average unshared data size
                   0  average unshared stack size
                9111  page reclaims
                   6  page faults
                   0  swaps
                   0  block input operations
                   0  block output operations
                   0  messages sent
                   0  messages received
                   0  signals received
                   0  voluntary context switches
                  34  involuntary context switches
           407840008  instructions retired
           131401346  cycles elapsed
           137036352  peak memory footprint

## no-gc-terminator
ruby 4.1.0dev (2026-06-30T08:59:10Z no-gc-terminator c62340f23e) +PRISM [arm64-darwin25]
parent: 10000000 bytes
slices: 1000 x 100000 bytes (naive copy total: 100MB)
heap_live_slots: 19814
        0.02 real         0.02 user         0.00 sys
            29999104  maximum resident set size
                   0  average shared memory size
                   0  average unshared data size
                   0  average unshared stack size
                2092  page reclaims
                   5  page faults
                   0  swaps
                   0  block input operations
                   0  block output operations
                   0  messages sent
                   0  messages received
                   0  signals received
                   0  voluntary context switches
                  19  involuntary context switches
           304597394  instructions retired
            94981761  cycles elapsed
            21873120  peak memory footprint

# bench_memory_retention_risk
## master
ruby 4.1.0dev (2026-06-21T03:05:27Z master a2b9d6ff3b) +PRISM [arm64-darwin25]
iterations: 100, parent: 1000000 bytes each
live data needed: 100000 bytes
total live string memory after GC: 615425 bytes
heap_live_slots: 19023

## no-gc-terminator
ruby 4.1.0dev (2026-06-30T08:59:10Z no-gc-terminator c62340f23e) +PRISM [arm64-darwin25]
iterations: 100, parent: 1000000 bytes each
live data needed: 100000 bytes
total live string memory after GC: 100521809 bytes
heap_live_slots: 19129

# bench_repeated_rstring_ptr
## rstring-raw-ptr-explicit-length-ops
ruby 4.1.0dev (2026-06-26T13:52:35Z rstring-raw-ptr-ex.. 03644c15ba) +PRISM [arm64-darwin25]
N=1000000

ELTS_SHARED  str.to_f (repeated)                   13658776 ops/s
independent  str.to_f (repeated)                   15156108 ops/s

## no-gc-terminator
ruby 4.1.0dev (2026-06-30T08:59:10Z no-gc-terminator c62340f23e) +PRISM [arm64-darwin25]
N=1000000

ELTS_SHARED  str.to_f (repeated)                   15198723 ops/s
independent  str.to_f (repeated)                   15106197 ops/s

# bench_many_gvl_term
## rstring-raw-ptr-explicit-length-ops
ruby 4.1.0dev (2026-06-26T13:52:35Z rstring-raw-ptr-ex.. 03644c15ba) +PRISM [arm64-darwin25]
N_SLICES=1000, SLICE_SIZE=100000 bytes (total ~100 MB)

first pass  (1000 different ELTS_SHARED strings)          74884 ops/s

RSS before first pass:    29328 KB
RSS after first pass:    141712 KB  (+112384 KB)
RSS after GC:            141744 KB  (+112416 KB)
heap_live_slots after GC: 19869

## no-gc-terminator
ruby 4.1.0dev (2026-06-30T08:59:10Z no-gc-terminator c62340f23e) +PRISM [arm64-darwin25]
N_SLICES=1000, SLICE_SIZE=100000 bytes (total ~100 MB)

first pass  (1000 different ELTS_SHARED strings)         115996 ops/s

RSS before first pass:    29248 KB
RSS after first pass:    141520 KB  (+112272 KB)
RSS after GC:            141520 KB  (+112272 KB)
heap_live_slots after GC: 19874
