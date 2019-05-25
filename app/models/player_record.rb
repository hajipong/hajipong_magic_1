class PlayerRecord
  include ActiveModel::Model
  attr_accessor :num, :family_name, :first_name, :short_name, :games, :after, :area, :rank, :score

  def initialize(player_record_arrays)
    @num = player_record_arrays[0][0]
    @family_name = player_record_arrays[0][1]
    @first_name = player_record_arrays[0][2]
    @short_name = player_record_arrays[0][3]

    index = -1
    @area = is_area_text?(player_record_arrays[1][index.succ]) ? player_record_arrays[1][index = index.succ] : ''
    @rank = is_rank_text?(player_record_arrays[1][index.succ]) ? player_record_arrays[1][index = index.succ] : ''

    make_result(player_record_arrays, index)
  end

  def make_result(player_record_arrays, under_index)
    over_line = player_record_arrays[0]
    under_line = player_record_arrays[1]
    @games = over_line.map do |game_text|
      if is_result_text?(game_text)
        Game.new(game_text, under_line[under_index = under_index.succ])
      else
        nil
      end
    end
  end

  def is_result_text?(text)
    text.include?('○') || text.include?('×') || text.include?('△')
  end

  def is_rank_text?(text)
    RANK_WORDS.include? text
  end

  def is_area_text?(text)
    AREAS.include? text
  end

  RANK_WORDS = %w(初段 二段 三段 四段 五段 六段 七段 八段 九段 1級 2級 3級 4級 5級 6級 7級 8級 9級).freeze
  
  AREAS = %w(北海道 青森 岩手 宮城 秋田 山形 福島 茨城 栃木 群馬 埼玉 千葉 東京 神奈川 新潟 富山 石川 福井
            山梨 長野 岐阜 静岡 愛知 三重 滋賀 京都 大阪 兵庫 奈良 和歌山 鳥取 島根 岡山 広島 山口 徳島
            香川 愛媛 高知 福岡 佐賀 長崎 熊本 大分 宮崎 鹿児島 沖縄
            東北 北関東 東関東 東海 中部 近畿北陸 中四国 九州).freeze
end