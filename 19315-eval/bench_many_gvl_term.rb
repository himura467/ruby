# Concern: many ELTS_SHARED strings accumulating in gvl_term_table.
# 1000 slices x 100KB = ~100MB total, exceeding mimalloc's pre-committed
# segments so that RSS reflects actual allocation.

PARENT = ("a" * 10_000_000).freeze
SLICE_SIZE = 100_000
N_SLICES = 1_000
SLICES = Array.new(N_SLICES) { |i| PARENT[i % (PARENT.bytesize - SLICE_SIZE), SLICE_SIZE] }

def rss_kb
  `ps -o rss= -p #{Process.pid}`.strip.to_i
end

def measure(label, total)
  start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  yield
  elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
  printf("%-52s %10.0f ops/s\n", label, total / elapsed)
end

puts RUBY_DESCRIPTION
puts "N_SLICES=#{N_SLICES}, SLICE_SIZE=#{SLICE_SIZE} bytes (total ~#{N_SLICES * SLICE_SIZE / 1_000_000} MB)"
puts

GC.start
rss_before = rss_kb

measure("first pass  (#{N_SLICES} different ELTS_SHARED strings)", N_SLICES) do
  SLICES.each(&:to_f)
end
rss_after_first = rss_kb

GC.start
rss_after_gc = rss_kb
puts
printf("RSS before first pass:  %7d KB\n", rss_before)
printf("RSS after first pass:   %7d KB  (+%d KB)\n", rss_after_first, rss_after_first - rss_before)
printf("RSS after GC:           %7d KB  (+%d KB)\n", rss_after_gc, rss_after_gc - rss_before)
puts "heap_live_slots after GC: #{GC.stat[:heap_live_slots]}"
