namespace :permissions do
  desc "Randomly assign permissions to users and applications"
  task assign_random: :environment do
    users = User.all.to_a
    apps  = Application.all.to_a

    if users.empty? || apps.empty?
      puts "No users or applications found. Aborting."
      next
    end

    puts "Assigning random permissions..."

    20.times do
      user = users.sample
      app  = apps.sample

      Permission.create!(
        user: user,
        application: app,
        access_level: rand(0..1),           
        can_read: [true, false].sample,   
        can_write: [true, false].sample,
        can_delete: [true, false].sample
      )

      puts " Assigned permissions to User##{user.id} for App##{app.id}"
    end

    puts "Done! "
  end
end
