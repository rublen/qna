module SearchesHelper
  def link_to_question(item)
    case
    when item.is_a?(Question)
      link_to item.title, question_path(item)

    when item.is_a?(Answer)
      link_to item.question.title, question_path(item.question)

    when item.is_a?(Comment) && item.commentable.is_a?(Question)
      link_to item.commentable.title, question_path(item.commentable)

    when item.is_a?(Comment) && item.commentable.is_a?(Answer)
      link_to item.commentable.question.title, question_path(item.commentable.question)
    end
  end
end
