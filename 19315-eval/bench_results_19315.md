# bench_speed_scaling
## master
ruby 4.1.0dev (2026-06-21T03:05:27Z master a2b9d6ff3b) +PRISM [arm64-darwin25]
parent: 20000000 bytes, offset: 1000000, N=10000

middle slice [1000000, 1000]                      4885198 ops/s
middle slice [1000000, 10000]                      694444 ops/s
middle slice [1000000, 100000]                     279791 ops/s
middle slice [1000000, 1000000]                     55168 ops/s
middle slice [1000000, 10000000]                     2458 ops/s
tail   slice [-10_000_000, 10_000_000] (control)   11325028 ops/s

## current
ruby 4.1.0dev (2026-06-21T06:50:18Z rstring-raw-ptr-ex.. c7eace4288) +PRISM [arm64-darwin25]
parent: 20000000 bytes, offset: 1000000, N=10000

middle slice [1000000, 1000]                      9066183 ops/s
middle slice [1000000, 10000]                    10672359 ops/s
middle slice [1000000, 100000]                   11441648 ops/s
middle slice [1000000, 1000000]                  11614402 ops/s
middle slice [1000000, 10000000]                 11574074 ops/s
tail   slice [-10_000_000, 10_000_000] (control)    8960573 ops/s

# bench_small_string_slice
## master
ruby 4.1.0dev (2026-06-21T03:05:27Z master a2b9d6ff3b) +PRISM [arm64-darwin25]
parent: 10000 bytes, N=100000
embed threshold: len <= 999 bytes (64-bit)

slice [0, 100] (embedded)                               7678133 ops/s
slice [0, 100] + == (embedded)                          9555662 ops/s
slice [0, 1000] (ELTS_SHARED)                           4822298 ops/s
slice [0, 1000] + == (ELTS_SHARED)                      4472672 ops/s
slice [0, 10000] (ELTS_SHARED)                          7029877 ops/s
slice [0, 10000] + == (ELTS_SHARED)                    10231226 ops/s

## current
ruby 4.1.0dev (2026-06-21T06:50:18Z rstring-raw-ptr-ex.. c7eace4288) +PRISM [arm64-darwin25]
parent: 10000 bytes, N=100000
embed threshold: len <= 999 bytes (64-bit)

slice [0, 100] (embedded)                               9218289 ops/s
slice [0, 100] + == (embedded)                         11248594 ops/s
slice [0, 1000] (ELTS_SHARED)                          11224604 ops/s
slice [0, 1000] + == (ELTS_SHARED)                     10094892 ops/s
slice [0, 10000] (ELTS_SHARED)                         11879306 ops/s
slice [0, 10000] + == (ELTS_SHARED)                     9632055 ops/s

# bench_memory_sharing_win
## master
ruby 4.1.0dev (2026-06-21T03:05:27Z master a2b9d6ff3b) +PRISM [arm64-darwin25]
parent: 10000000 bytes
slices: 1000 x 100000 bytes (naive copy total: 100MB)
heap_live_slots: 19802
        0.04 real         0.03 user         0.01 sys
           144703488  maximum resident set size
                   0  average shared memory size
                   0  average unshared data size
                   0  average unshared stack size
                9088  page reclaims
                   6  page faults
                   0  swaps
                   0  block input operations
                   0  block output operations
                   0  messages sent
                   0  messages received
                   0  signals received
                   0  voluntary context switches
                  46  involuntary context switches
           411979562  instructions retired
           132615424  cycles elapsed
           136675904  peak memory footprint

## current
ruby 4.1.0dev (2026-06-21T06:50:18Z rstring-raw-ptr-ex.. c7eace4288) +PRISM [arm64-darwin25]
parent: 10000000 bytes
slices: 1000 x 100000 bytes (naive copy total: 100MB)
heap_live_slots: 19810
        0.03 real         0.02 user         0.00 sys
            30081024  maximum resident set size
                   0  average shared memory size
                   0  average unshared data size
                   0  average unshared stack size
                2096  page reclaims
                   5  page faults
                   0  swaps
                   0  block input operations
                   0  block output operations
                   0  messages sent
                   0  messages received
                   0  signals received
                   0  voluntary context switches
                  25  involuntary context switches
           305206729  instructions retired
            99664081  cycles elapsed
            21955016  peak memory footprint



# bench_memory_retention_risk
## master
ruby 4.1.0dev (2026-06-21T03:05:27Z master a2b9d6ff3b) +PRISM [arm64-darwin25]
iterations: 100, parent: 1000000 bytes each
live data needed: 100000 bytes
total live string memory after GC: 615345 bytes
heap_live_slots: 19019

## current
ruby 4.1.0dev (2026-06-21T06:50:18Z rstring-raw-ptr-ex.. c7eace4288) +PRISM [arm64-darwin25]
iterations: 100, parent: 1000000 bytes each
live data needed: 100000 bytes
total live string memory after GC: 100521729 bytes
heap_live_slots: 19124
