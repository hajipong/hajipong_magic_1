class PlayerRecord
  include ActiveModel::Model
  attr_accessor :num, :family_name, :first_name, :short_name, :results, :after, :area, :rank, :score

  def self.generate(result_text)

  end
end