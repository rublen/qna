# QnA (Questions and Answers)

#### Ruby version 2.5.0
#### Rails version 5.2.1
#### DataBase PostgreSQL 10.6

It's a training project which was done within the advanced programme of Ruby on Rails course of online coding school Thinknetica. The idea of the project is to allow people to help each other in solving problems via asking and answering questions.

#### Entity list
- user/admin
- question
- answer
- comment
- attachment
- vote
- subscription
- authorization


#### Functionality
- Authentication
- OAuth with GitHub
- Creating and managing questions
- Creating and managing answers
- Commenting on questions or answers
- Searching 1) a quick search in the questions list 2) search also in other entities separately or in altogether
- Possibility to attach files for questions and answers
- Voting up or down for question/answer (excluding its author). Every user can change the score of the question/answer only by 1 (up) or -1 (down) point. Of course, he can change his mind and revote or unvote. Feel free doing that, no one knows who votes
- Every new user subscribes automatically for daily newsletters with the list of new questions of the last day. Sure, he can unsubscribe, there is a link in the email and on the main page
- The author of the question subscribes automatically for informational letters about every new answer for his question. He can unsubscribe, there is a link in the email and on the question page
- Every user can Subscribe/Unsubscribe daily newsletters with the link on the main page and can Follow/Unfollow any question with the link on the question page
- Guest can search and read everything


#### API
###### General information
- http://104.248.89.162/oauth/applications - creating an app for using QnA as OAuth2 provider
- The base endpoint is: http://104.248.89.162
- All endpoints return a JSON object
###### Endpoints
##### My profile
- GET /api/v1/profiles/me.json?access_token=XXXXXXX 

##### Other profiles
- GET /api/v1/profiles.json?access_token=XXXXXXX

##### List of questions 
- GET /api/v1/questions.json?access_token=XXXXXXX 

##### Show question
- GET /api/v1/questions/:id.json?access_token=XXXXXXX

##### Create a new question
- POST /api/v1/questions.json
- Request body: title=TITLE&body=BODY&access_token=XXXXXXX

##### List of question's answers
- GET /api/v1/questions/:question_id.answers.json?access_token=XXXXXXX

##### Create an answer for the question
- POST /api/v1/questions/:question_id/answers.json
- Request body: body=BODY&access_token=XXXXXXX



##### Show answer
- GET /api/v1/answers/:id.json?access_token=XXXXXXX


#### Used technologies
- AJAX and JavaScript
- Slim and Bootstrap
- Nested forms
- OmniAuth
- WebSockets (through ActionCable)


#### Services
- 'whenever' for job queues
- 'Sidekiq' for performing jobs
- 'Sphinx' as search engine
- 'doorkeeper' as  an OAuth 2 provider for Ruby on Rails

#### Testing technologies
- RSpec
- Capybara
