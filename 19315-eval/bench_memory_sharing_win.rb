# Memory win: 1_000 overlapping 100KB slices from one 10MB parent, all kept alive.
# Without SHARABLE_MIDDLE_SUBSTRING: 1_000 x 100KB = 100MB of copies + 10MB parent.
# With it: slices share the parent buffer; RSS stays close to the parent size.
#
# Measure with: /usr/bin/time -l <ruby> 19315-eval/bench_memory_sharing_win.rb

PARENT_SIZE = 10_000_000
SLICE_SIZE  = 100_000
SLICES      = 1_000

parent = "p" * PARENT_SIZE
slices = Array.new(SLICES) do |i|
  offset = (i * 10_000) % (PARENT_SIZE - SLICE_SIZE)
  parent[offset, SLICE_SIZE]
end

GC.start

puts RUBY_DESCRIPTION
puts "parent: #{PARENT_SIZE} bytes"
puts "slices: #{SLICES} x #{SLICE_SIZE} bytes (naive copy total: #{SLICES * SLICE_SIZE / 1_000_000}MB)"
puts "heap_live_slots: #{GC.stat[:heap_live_slots]}"

at_exit { slices.size }
