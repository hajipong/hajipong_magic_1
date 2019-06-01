# 回ごとにマッチしてない対局を探して不戦の空白を挿入するクラス
class GameTimingGenerator
  include ActiveModel::Model

  def initialize(player_records)
    @player_records = player_records
  end

  def generate
    game_count = 0
    begin
      has_data = false
      @player_records.each do |player_record|
        if player_record.games.length > game_count
          has_data = true
        else
          next
        end
        unless is_match?(player_record, game_count)
          player_record.games.insert(game_count, EmptyGame.new)
        end
      end
      game_count = game_count + 1
    end while has_data
  end

  private

  def is_match?(player_record, count)
    game = player_record.games[count]
    game.is_empty? || is_match_name?(player_record.short_name, game.player, count)
  end

  def is_match_name?(short_name, player_short_name, count)
    @player_records.find { |player_record| player_record.short_name == player_short_name}
        .games[count].player == short_name
  end
end
