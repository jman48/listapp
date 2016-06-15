namespace :migrate do
  require 'auth0'

  desc 'Update users from auth0 to local db'
  task users: :environment do
    puts 'Updating users'

    auth0 = Auth0Client.new(
        :api_version => 2,
        :token => ENV['AUTH0_TOKEN'],
        :domain => "john.au.auth0.com"
    )

    users = auth0.users
    puts 'Retrived ' + users.count.to_s + ' users'

    new_users_count = 0

    users.each { |user|
      user_model = User.find_by_user_id(user['user_id'])

      if user_model
        user_model.update!(
            email: user['email'],
            picture: user['picture']
        )
      else
        new_users_count += 1
        user_name = User.get_unique_username(user['nickname'])

        User.create!(
            user_id: user['user_id'],
            username: user_name,
            email: user['email'],
            picture: user['picture']
        )
      end
    }

    puts 'Created ' + new_users_count.to_s + ' new users'
    puts 'All users updated'
  end
end