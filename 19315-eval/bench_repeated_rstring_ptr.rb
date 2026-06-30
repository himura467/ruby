# Concern: repeated RSTRING_PTR calls on the same ELTS_SHARED string.
#
# On master: first call triggers str_make_independent_expand (unshares string);
# subsequent calls return the buffer directly at no extra cost.
#
# On no-gc-terminator: string stays ELTS_SHARED; every call hits st_lookup in
# gvl_term_table (cheap but not free).

PARENT = ("a" * 20_000).freeze
SUBSTR = PARENT[10_000, 4]   # ELTS_SHARED
INDEPENDENT = SUBSTR.dup     # not ELTS_SHARED

N = 1_000_000

def measure(label, n)
  start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  n.times { yield }
  elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
  printf("%-48s %10.0f ops/s\n", label, n / elapsed)
end

puts RUBY_DESCRIPTION
puts "N=#{N}"
puts

measure("ELTS_SHARED  str.to_f (repeated)", N) { SUBSTR.to_f }
measure("independent  str.to_f (repeated)", N) { INDEPENDENT.to_f }
