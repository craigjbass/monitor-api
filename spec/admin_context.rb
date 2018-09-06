RSpec.shared_context 'as admin' do
  def set_correct_auth_header
    header 'API_KEY', 'supersecret'
  end

  def set_incorrect_auth_header
    header 'API_KEY', 'wrongsecret'
  end
end
