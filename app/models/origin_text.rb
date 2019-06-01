# 元のテキストをデータ解析するクラス
class OriginText
  include ActiveModel::Model
  attr_accessor :first_half, :second_half

  def first_half_player_records
    to_player_record(first_half)
  end

  def second_half_player_records
    to_player_record(second_half)
  end

  private

  # 元のテキストを選手ごとのオブジェクト化
  def to_player_record(original)
    original.lines               # 改行で区切って行ごとの配列化
        .map(&method(:to_line_array)) # 行をスペースで区切って配列化
        .compact                        # ノイズを除去
        .each_slice(2)                  # ２行ずつ区切ってループ
        .map { |player_record_array| player_record_array }
                                        # ２行ずつ単位を配列化
  end

  # 1行のテキストをスペース区切りで切った配列化
  def to_line_array(line_text)
    line = line_text.split(' ')
    line if line.length > 4     # 4区切り以下は対局データがないのでノイズと判断
  end

end