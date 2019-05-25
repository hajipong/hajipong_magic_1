# 元のテキストをデータ解析し、レーティング用出力をするクラス
class ResultText
  include ActiveModel::Model
  attr_accessor :original

  # 整形
  def format
    player_records = to_player_record_arrays.map { |player_record_arrays| PlayerRecord.new(player_record_arrays)}
    to_str(player_records)
  end

  private

  # 元のテキストを選手ごとのオブジェクト化
  def to_player_record_arrays
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

  # 選手データをレーティング用文字列に変換
  def to_str(player_records)
    format = PlayerRecordsFormatter.new(player_records)
    '<pre style="font-family: monospace; font-size: large">' +
        player_records.map { |player_record| format.to_str(player_record) + "<br />" }.join + '</pre>'
  end
end