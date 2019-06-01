# 二つの選手記録を一つにまとめるクラス
class PlayerRecordMerger
  include ActiveModel::Model

  def self.merge(first_half, second_half)
    second_half.each do |second_player_record|
      same_player_record = first_half.find { |first_player_record| first_player_record.same_player? second_player_record }
      if same_player_record
        same_player_record.games.concat(second_player_record.games)
      else
        first_half.push second_player_record
      end
    end
  end

end
