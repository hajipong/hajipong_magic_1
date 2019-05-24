class ResultText
  include ActiveModel::Model
  attr_accessor :original

  def format
    fuga = original.split('\n')
    fuga.each do |f|
      hoge = f.split(' ')
    end
    "変換したよ！"
  end
end