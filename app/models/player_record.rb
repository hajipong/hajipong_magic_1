# 選手記録のデータモデル
class PlayerRecord
  include ActiveModel::Model
  attr_accessor :num, :family_name, :first_name, :short_name, :games, :after, :area, :rank, :score

  RANK_WORDS = %w(初段 二段 三段 四段 五段 六段 七段 八段 九段 １級 ２級 ３級 ４級 ５級 ６級 ７級 ８級 ９級).freeze

  AREAS = %w(北海道 青森 岩手 宮城 秋田 山形 福島 茨城 栃木 群馬 埼玉 千葉 東京 神奈川 新潟 富山 石川 福井
            山梨 長野 岐阜 静岡 愛知 三重 滋賀 京都 大阪 兵庫 奈良 和歌山 鳥取 島根 岡山 広島 山口 徳島
            香川 愛媛 高知 福岡 佐賀 長崎 熊本 大分 宮崎 鹿児島 沖縄
            東北 北関東 東関東 東海 中部 近畿北陸 中四国 九州).freeze

  def initialize(player_record_arrays)
    @player_record_arrays = player_record_arrays
    generate
  end

  def same_player?(other_player_record)
    family_name == other_player_record.family_name && first_name == other_player_record.first_name
  end

  private

  # 元データ上段
  def over_line
    @player_record_arrays[0]
  end

  # 元データ下段
  def under_line
    @player_record_arrays[1]
  end

  # 元データからデータ生成
  def generate
    @num = over_line[0]
    @family_name = over_line[1]
    @first_name = over_line[2]
    @short_name = over_line[3]

    index = -1
    @area = is_area_text?(under_line[index.succ]) ? under_line[index = index.succ] : ''
    @rank = is_rank_text?(under_line[index.succ]) ? under_line[index = index.succ] : ''

    make_result(index)
  end

  # 元データから対局データ生成
  def make_result(under_index)
    over_index = 4
    @games = over_line.map.with_index do |game_text, index|
      if is_result_text?(game_text)
        over_index = index
        game_text = game_text + ' ' + over_line[over_index = over_index.succ] if has_not_point?(game_text)
        Game.new(game_text, under_line[under_index = under_index.succ])
      else
        nil
      end
    end
    @after = over_line.map.with_index { |text, i| (i > over_index) ? text : nil}.compact.join(' ')
    @score = under_line.map.with_index { |text, i| (i > under_index) ? text : nil}.compact.join(' ')
  end

  # 対局石数が含まれているか？
  def has_not_point?(text)
    text.gsub(/[^\d]/, "").length == 0
  end

  # 対局カラムか？
  def is_result_text?(text)
    text.include?('○') || text.include?('×') || text.include?('△')
  end

  # 段位カラムか？
  def is_rank_text?(text)
    RANK_WORDS.include? text
  end

  # 地域カラムか？
  def is_area_text?(text)
    AREAS.include? text
  end
end