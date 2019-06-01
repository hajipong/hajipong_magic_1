# 全員の選手記録を考慮して各項目を均等なスペースにする
# レーティング用文字列整形クラス
class PlayerRecordsFormatter
  include ActiveModel::Model
  attr_accessor :num_length, :name_length, :short_name_length, :game_count, :game_length, :area_length, :rank_length

  def initialize(player_records)
    @player_records = player_records
    hold_max_item_length
  end

  # 各項目の最大文字数を保持する
  def hold_max_item_length
    @player_records.each do |player_record|
      @num_length = [@num_length ||= 0, text_length(player_record.num)].max
      @name_length = [@name_length ||= 0, text_length(player_record.family_name) + text_length(player_record.first_name)].max
      @short_name_length = [@short_name_length ||= 0, text_length(player_record.short_name)].max
      @game_length = [@game_length ||= 0, get_max_game_length(player_record.games)].max
      @game_count = [@game_count ||= 0, player_record.games.length].max
    end
    @area_length = @name_length + PlayerRecordFormatter::SPACES[:family_name]
    @rank_length = @short_name_length
  end

  # 対局記録の最大文字数を取り出す
  def get_max_game_length(games)
    games.map { |game| [text_length(game.win_lose + game.point), text_length(game.player)].max }.max
  end

  # 選手記録をレーティング文字列変換
  def to_str(player_record)
    f = PlayerRecordFormatter.new(self, player_record)
    f.num + f.name + f.shot_name + f.games + f.after + '<br />' +
        f.under_num + f.area + f.rank + f.players + f.score
  end

  # 全角を半角2文字とカウントした文字列カウント
  def text_length(text)
    text.length + text.chars.reject(&:ascii_only?).length
  end
end