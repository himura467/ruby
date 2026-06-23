# Regression check for common slicing patterns across the embed threshold.
# Embed threshold (64-bit): len <= 999B → copied into GC slot on both builds.
# len >= 1000B → ELTS_SHARED on this branch, full copy on master.

PARENT = ("a" * 10_000).freeze
N = 100_000

def measure(label)
  start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  N.times { yield }
  elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
  printf("%-52s %10.0f ops/s\n", label, N / elapsed)
end

puts RUBY_DESCRIPTION
puts "parent: #{PARENT.bytesize} bytes, N=#{N}"
puts "embed threshold: len <= 999 bytes (64-bit)"
puts

[100, 1_000, 10_000].each do |size|
  tag = size <= 999 ? "embedded" : "ELTS_SHARED"
  other = PARENT[0, size].freeze
  measure("slice [0, #{size}] (#{tag})") { PARENT[0, size] }
  measure("slice [0, #{size}] + == (#{tag})") { PARENT[0, size] == other }
end
