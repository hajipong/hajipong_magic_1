class TopController < ApplicationController

  def convert
    origin_text = OriginText.new(origin_text_params)
    render plain: FormatTextGenerator.new(origin_text).generate
  end

  def origin_text_params
    params.require(:origin_text).permit(:first_half, :second_half)
  end
end
