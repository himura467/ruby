# Memory risk: 100 iterations, each building a 1MB parent and keeping only a
# 1KB slice.  Without SHARABLE_MIDDLE_SUBSTRING the parent is freed by GC;
# with it the ELTS_SHARED slice holds the parent buffer alive (Java concern).
#
# Metric: ObjectSpace.memsize_of_all(String) after GC (post-GC retained memory).
# SLICE_SIZE >= 1_000 to exceed the 999B embed threshold and trigger ELTS_SHARED.

require 'objspace'

PARENT_SIZE = 1_000_000
SLICE_SIZE  = 1_000
ITERATIONS  = 100

tiny_slices = Array.new(ITERATIONS) do
  parent = "q" * PARENT_SIZE
  parent[100_000, SLICE_SIZE]
end

3.times { GC.start }

str_memory = ObjectSpace.memsize_of_all(String)

puts RUBY_DESCRIPTION
puts "iterations: #{ITERATIONS}, parent: #{PARENT_SIZE} bytes each"
puts "live data needed: #{ITERATIONS * SLICE_SIZE} bytes"
puts "total live string memory after GC: #{str_memory} bytes"
puts "heap_live_slots: #{GC.stat[:heap_live_slots]}"

at_exit { tiny_slices.size }
