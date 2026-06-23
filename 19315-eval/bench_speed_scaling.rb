# Middle-slice throughput: O(n) on master vs O(1) on this branch.
# Slices <=999B are embedded on both builds; speedup appears above that threshold.
# Tail slice is a control (both builds were already O(1) there).

PARENT = ("a" * 20_000_000).freeze
OFFSET = 1_000_000
N = 10_000

def measure(label)
  start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  N.times { yield }
  elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
  printf("%-46s %10.0f ops/s\n", label, N / elapsed)
end

puts RUBY_DESCRIPTION
puts "parent: #{PARENT.bytesize} bytes, offset: #{OFFSET}, N=#{N}"
puts

[1_000, 10_000, 100_000, 1_000_000, 10_000_000].each do |size|
  measure("middle slice [#{OFFSET}, #{size}]") { PARENT[OFFSET, size] }
end
measure("tail   slice [-10_000_000, 10_000_000] (control)") { PARENT[-10_000_000, 10_000_000] }
