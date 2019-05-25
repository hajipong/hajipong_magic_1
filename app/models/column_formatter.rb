class ColumnFormatter
  include ActiveModel::Model
  attr_accessor :num_length, :name_length, :short_name_length, :result_lengths, :area_length, :rank_length
  SPACES = {num: 1, family_name: 1, first_name: 1, short_name: 2, game: 2, area: 1, rank: 2}.freeze

  def initialize(player_records)
    player_records.each do |player_record|
      @num_length = [@num_length ||= 0, text_length(player_record.num)].max
      @name_length = [@name_length ||= 0, text_length(player_record.family_name) + text_length(player_record.first_name)].max
      @short_name_length = [@short_name_length ||= 0, text_length(player_record.short_name)].max
    end
    @area_length = @name_length + SPACES[:family_name]
    @rank_length = @short_name_length
  end

  def to_str(player_record)
    space(margin(player_record.num, @num_length)) + player_record.num + space(SPACES[:num]) +
        player_record.family_name + space(SPACES[:family_name]) + player_record.first_name +
        space(margin(player_record.family_name + player_record.first_name, @name_length) + SPACES[:first_name]) +
        player_record.short_name + space(margin(player_record.short_name, @short_name_length) + SPACES[:short_name]) +
        player_record.games.compact.map(&:win_lose).join(space(SPACES[:game])) +
        '<br />' +
        space(margin('', @num_length) + SPACES[:num]) +
        player_record.area + space(margin(player_record.area, @area_length) + SPACES[:area]) +
        player_record.rank + space(margin(player_record.rank, @rank_length) + SPACES[:rank]) +
        player_record.games.compact.map(&:player).join(space(SPACES[:game]))
  end

  private

  def margin(target_value, max_length)
    max_length - text_length(target_value)
  end

  def space(num)
    ' ' * num
  end

  def text_length(text)
    text.length + text.chars.reject(&:ascii_only?).length
  end
end