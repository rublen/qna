shared_examples_for "API Authorizable" do
  it "returns 401 status if there is no access_token" do
    do_request
    expect(response.status).to eq 401
  end

  it "returns 401 status if access_token is invalid" do
    do_request(access_token: '123456')
    expect(response.status).to eq 401
  end

  it "returns status 200 or is successful" do
    do_request(access_token: access_token.token)
    expect(response).to be_successful
  end
end
