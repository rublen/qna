class SearchesController < ApplicationController
  skip_before_action :authenticate_user!

  def search
    return if params[:search].to_s.empty?

    @items = if params[:search_options]
      params[:search_options].constantize.send(:search, params[:search], limit: 500)
    else
      ThinkingSphinx.search(params[:search], limit: 500)
    end

    @pagy, @items = pagy_array(@items, items: 10)
  end
end
