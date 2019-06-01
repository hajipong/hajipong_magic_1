class TopController < ApplicationController

  def convert
    @result_text = ResultText.new(result_text_params)
    render plain: @result_text.format
  end

  def result_text_params
    params.require(:result_text).permit(:first_half, :second_half)
  end
end
