# 不完全な記録テキストからレーティング読み取り可能なテキスト生成クラス
class FormatTextGenerator
  include ActiveModel::Model

  def initialize(origin_text)
    @origin_text = origin_text
  end

  # 整形
  def generate
    begin
      player_records = @origin_text.first_half_player_records.map { |player_record_arrays| PlayerRecord.new(player_record_arrays)}
      if @origin_text.second_half
        second_player_records = @origin_text.second_half_player_records.map { |player_record_arrays| PlayerRecord.new(player_record_arrays)}
        PlayerRecordMerger.merge(player_records, second_player_records)
      end
      GameTimingGenerator.new(player_records).generate
      to_str(player_records)
    rescue => error
      '<pre style="font-family: monospace; font-size: large">' +
          '変換できませんでした。データ区切りは以下の通り<br />' +
          @origin_text.get_result +
          '</pre>'
    end
  end

  # 選手データをレーティング用文字列に変換
  def to_str(player_records)
    format = PlayerRecordsFormatter.new(player_records)
    '<pre style="font-family: monospace; font-size: large">' +
        player_records.map { |player_record| format.to_str(player_record) + "<br />" }.join + '</pre>'
  end

end
