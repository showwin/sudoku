file = ARGV[0] || 'result'
ipt = File.open("#{file}.txt", 'r')
table = Array.new(9, Array.new(9))
i = 0
ipt.each_line do |row|
  table[i] = row.chomp.split(',')
  i += 1
end

def check_sum(arr_9)
  45 == arr_9.map(&:to_i).inject { |sum, n| sum + n }
end

flg = true

# 横のチェック
9.times do |i|
  flg &&= check_sum(table[i])
end

# 縦のチェック
9.times do |i|
  arr = []
  9.times do |j|
    arr << table[i][j]
  end
  flg &&= check_sum(arr)
end

# 四角のチェック
9.times do |i|
  x, y = i / 3, i % 3
  xs, ys = x * 3, y * 3
  arr = []
  3.times do |j|
    3.times do |k|
      arr << table[xs + j][ys + k]
    end
  end
  flg &&= check_sum(arr)
end

p flg
