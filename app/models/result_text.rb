class ResultText
  include ActiveModel::Model
  attr_accessor :original

  def format
    player_records = to_player_record_arrays.map { |player_record_arrays| PlayerRecord.new(player_record_arrays)}
    to_str(player_records)
  end

  private

  def to_player_record_arrays
    original.lines               # 改行で区切って行ごとの配列化
        .map(&method(:to_array)) # 行をスペースで区切って配列化
        .compact                        # ノイズを除去
        .each_slice(2)                  # ２行ずつ区切ってループ
        .map { |player_record_array| player_record_array }
                                        # ２行ずつ単位を配列化
  end

  def to_array(line_text)
    line = line_text.split(' ')
    line if line.length > 4
  end

  def to_str(player_records)
    format = ColumnFormatter.new(player_records)
    '<pre style="font-family: monospace; font-size: large">' + player_records.map { |player_record| format.to_str(player_record) + "<br />" }.join + '</pre>'
  end
end