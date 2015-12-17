require 'benchmark'
puts Benchmark::CAPTION

# データ計測
result = Benchmark.measure{
  file = ARGV[0] || 'script.rb'
  # 計測したい処理
  `ruby #{file}`
}

# 結果表示
puts result
