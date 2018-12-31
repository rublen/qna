require 'rails_helper'

RSpec.describe SearchesHelper, type: :helper do
  describe "link_to_question with parameter 'item'" do
    it "returns link to question if item is question" do
      item = create(:question)
      expect(helper.link_to_question(item)).to include "href=\"#{question_path(item)}\""
    end

    it "returns link to parent question if item is answer" do
      item = create(:answer)
      expect(helper.link_to_question(item)).to include "href=\"#{question_path(item.question)}\""
    end

    it "returns link to question if item is comment and it's commentable is question" do
      item = create(:question_comment)
      expect(helper.link_to_question(item)).to include "href=\"#{question_path(item.commentable)}\""
    end

    it "returns link to answer's question if item is comment and it's commentable is answer" do
      item = create(:answer_comment)
      expect(helper.link_to_question(item)).to include "href=\"#{question_path(item.commentable.question)}\""
    end
  end
end
