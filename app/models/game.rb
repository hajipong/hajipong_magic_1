# 対局データモデル
class Game
  include ActiveModel::Model
  attr_accessor :win_lose, :point, :player

  def initialize(game_text, player_text)
    @win_lose = game_text[/○|×|△/]
    @point = game_text.sub(/○|×|△/, '')
    @player = player_text
  end
end