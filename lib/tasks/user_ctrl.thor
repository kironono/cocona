class UserCtrl < Thor

  desc 'create', 'create user'
  option :name, required: true
  option :email, required: true
  option :password, required: true
  def create
    user = User.new(
      name: options[:name],
      email: options[:email],
      password: options[:password],
      locale: 'ja',
    )
    if user.valid?
      user.save!
    else
      puts user.errors.full_messages.join("\n")
    end
  end

end
