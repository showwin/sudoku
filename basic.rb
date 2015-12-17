### 最適化せずに、総当りでどれ位時間がかかるのかやろうとした。
### 途中になっている
#  |---------→ Y
#  | 0,0 0,1 0,2
#  | 1,0 1,1 1,2
#  ↓ 2,0 2,1 2,2
#  X

# x,y を含む正方形の四角の座標
def square_xy(x, y)
  xs, ys = (x / 3) * 3, (y / 3) * 3
  arr = []
  3.times do |j|
    3.times do |k|
      arr << [xs + j, ys + k]
    end
  end
  arr
end

# x,y に入る可能性のある数値の配列を返す
def search_candidate(table, x, y)
  # 横
  arr = table[x].dup
  # 縦
  9.times do |i|
    arr << table[i][y]
  end
  # 四角
  square_xy(x, y).each do |xx, yy|
    arr << table[xx][yy]
  end
  (1..9).to_a - arr
end

# ファイルを読み込んで、配列に落としこむ
file = ARGV[0] || 'input2'
ipt = File.open("#{file}.txt", 'r')
table = Array.new(9, Array.new(9))
i = 0
ipt.each_line do |row|
  table[i] = row.chomp.split(',').map(&:to_i)
  i += 1
end

def show_result(table)
  table.each do |row|
    puts row.join(',')
  end
end

def show_0
  9.times do
    puts '0,' * 8 + '0'
  end
end

table_dup = table.dup
cannot_solve = false

# 空欄に対して入る可能性のある数値を列挙する
can_table = {}
9.times do |x|
  9.times do |y|
    can_table["#{x},#{y}"] = search_candidate(table, x, y) if 0 == table[x][y]
  end
end

count = 1

@success_flg = false

def fill(table_dup, x, y)
  can_table["#{x},#{y}"].each do |num|
    table_dup[x][y] = num
    next_place = find_next(x, y)
    if next_place
      fill(table_dup, next_place[0], next_place[1])
    elsif check
      @success_flg = true
    end
    break if @success_flg
  end
end

fill(0, 0)

##############
# この辺途中
##############


loop do
  x += 1
  if x == 9
    x = 0
    y += 1
  end
  break if y == 8 && x == 8
  next if table[x][y] != 0
    old_x
  p can_table


  # 入る可能性が1つの数字しかない場合は、それを当てはめる
  can_table.each do |k, v|
    next unless v.size == 1
    nothing_change = false
    x, y = k.split(',').map(&:to_i)
    p "#{x}, #{y} = #{v[0]}"
    table[x][y] = v[0]
  end

  # 横を見て、確実に入れられるものを入れる
  9.times do |i|
    9.times do |j|
      can_other = []
      9.times do |k|
        next if j == k
        can_other << can_table["#{i},#{k}"]
      end
      puts "\n"
      p can_table["#{i},#{j}"]
      p can_other.flatten.uniq
      uniq = (can_table["#{i},#{j}"] || []) - can_other.flatten.uniq
      table[i][j] = uniq[0] unless uniq.empty?
      p "#{i}, #{j} = #{uniq[0]}" unless uniq.empty?
      nothing_change = false unless uniq.empty?
    end
  end

  # 縦を見て、確実に入れられるものを入れる
  9.times do |i|
    9.times do |j|
      can_other = []
      9.times do |k|
        next if j == k
        can_other << can_table["#{k},#{i}"]
      end
      puts "\n"
      p can_table["#{j},#{i}"]
      p can_other.flatten.uniq
      uniq = (can_table["#{j},#{i}"] || []) - can_other.flatten.uniq
      table[j][i] = uniq[0] unless uniq.empty?
      p "#{j}, #{i} = #{uniq[0]}" unless uniq.empty?
      nothing_change = false unless uniq.empty?
    end
  end

  break if nothing_change
  old_table = table.dup
  puts "==================== #{count} ========================="
  count += 1
end

#if nothing_change
#  show_0
#else
  show_result(table)
#end
