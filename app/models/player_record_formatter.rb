# 全員の選手記録を考慮して各項目を均等なスペースにする
# レーティング用文字列整形クラス
class PlayerRecordFormatter
  include ActiveModel::Model
  SPACES = {num: 1, family_name: 1, first_name: 1, short_name: 2, game: 2, area: 1, rank: 2}.freeze

  def initialize(parent_formatter, player_record)
    @parent_formatter = parent_formatter
    @player_record = player_record
  end

  # 各項目変換

  def num
    space(margin(r.num, p.num_length)) +
        r.num +
        space(SPACES[:num])
  end

  def name
    r.family_name +
        space(SPACES[:family_name]) +
        r.first_name +
        space(margin(r.family_name + r.first_name, p.name_length) + SPACES[:first_name])
  end

  def shot_name
    r.short_name + space(margin(r.short_name, p.short_name_length) + SPACES[:short_name])
  end

  def games
    texts = r.games.compact.map do |game|
      game.win_lose + game.point +
          space(margin(game.win_lose + game.point, p.game_length))
    end
    # 対局してない分のスペース追加
    (p.game_count - r.games.compact.length).times do
      texts.push(space(margin('', p.game_length)))
    end
    texts.join(space(SPACES[:game])) + space(SPACES[:game])
  end

  def under_num
    space(margin('', p.num_length) + SPACES[:num])
  end

  def area
    r.area + space(margin(r.area, p.area_length) + SPACES[:area])
  end

  def rank
    r.rank + space(margin(r.rank, p.rank_length) + SPACES[:rank])
  end

  def players
    texts = r.games.compact.map do |game|
      game.player + space(margin(game.player, p.game_length))
    end
    # 対局してない分のスペース追加
    (p.game_count - r.games.compact.length).times do
      texts.push(space(margin('', p.game_length)))
    end
    texts.join(space(SPACES[:game])) + space(SPACES[:game])
  end

  def after
    r.after
  end

  def score
    r.score
  end

  private

  # ↓省略用

  def r
    @player_record
  end

  def p
    @parent_formatter
  end

  # 該当項目の最大文字数を渡して、足りてない文字数分の余白スペース数を返す
  def margin(target_value, max_length)
    max_length - p.text_length(target_value)
  end

  # 指定数分半角スペースを作る
  def space(num)
    ' ' * num
  end
end