# Preview all emails at http://localhost:3000/rails/mailers/author_mailer
class AuthorMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/author_mailer/answers
  def answers
    AuthorMailerMailer.answers
  end

end
