User.destroy_all
Permission.destroy_all

# Users data
users_data = [
  { name: "Aman", email: "aman@example.com" },
  { name: "Anubhav", email: "anubhav@example.com" },
  { name: "Archana", email: "archana@example.com" },
  { name: "Chakri", email: "chakri@example.com" },
  { name: "Harshini", email: "harshini@example.com" },
  { name: "Kishore", email: "kishore@example.com" },
  { name: "Kousar", email: "kousar@example.com" },
  { name: "Lewis Hamilton", email: "lewis@example.com" },
  { name: "Manish", email: "manish@example.com" },
  { name: "Priyanka", email: "priyanka@example.com" },
  { name: "Ramya", email: "ramya@example.com" },
  { name: "Sandeep", email: "sandeep@example.com" },
  { name: "Shireesha", email: "shireesha@example.com" },
  { name: "Shiva", email: "shiva@example.com" },
  { name: "Shivathmika", email: "shivathmika@example.com" },
  { name: "Sriram", email: "sriram@example.com" },
  { name: "Subhash", email: "subhash@example.com" },
  { name: "Thomas Scott", email: "thomas@example.com" },
  { name: "Vinay", email: "vinay@example.com" },
  { name: "Alekhya", email: "alekhya@example.com" }
]

# Create Users
users = {}
users_data.each do |u|
  users[u[:name]] = User.create!(name: u[:name], email: u[:email], role: 0) # default to user
end

# Application URLs
apps_data = {
  "YouTube" => "https://www.youtube.com",
  "Facebook" => "https://www.facebook.com",
  "Instagram" => "https://www.instagram.com",
  "WhatsApp" => "https://www.whatsapp.com",
  "Gmail" => "https://mail.google.com",
  "Google Maps" => "https://maps.google.com",
  "Twitter" => "https://www.twitter.com",
  "Spotify" => "https://www.spotify.com",
  "Netflix" => "https://www.netflix.com",
  "Amazon" => "https://www.amazon.com"
}

applications = {}
apps_data.each do |name, url|
  applications[name] = Application.find_or_create_by!(name: name) do |app|
    app.url = url
    app.description = "#{name} app"
  end
end

# Permissions data
permissions_data = [
  { user: "Alekhya", app: "Instagram", level: "user" },
  { user: "Alekhya", app: "Netflix", level: "user" },
  { user: "Aman", app: "Gmail", level: "user" },
  { user: "Anubhav", app: "Instagram", level: "admin" },
  { user: "Archana", app: "Amazon", level: "user" },
  { user: "Archana", app: "Netflix", level: "admin" },
  { user: "Archana", app: "WhatsApp", level: "user" },
  { user: "Chakri", app: "Twitter", level: "admin" },
  { user: "Harshini", app: "Facebook", level: "user" },
  { user: "Harshini", app: "Instagram", level: "admin" },
  { user: "Harshini", app: "WhatsApp", level: "admin" },
  { user: "Kishore", app: "Facebook", level: "admin" },
  { user: "Kousar", app: "Gmail", level: "admin" },
  { user: "Kousar", app: "WhatsApp", level: "user" },
  { user: "Lewis Hamilton", app: "WhatsApp", level: "user" },
  { user: "Manish", app: "Facebook", level: "admin" },
  { user: "Manish", app: "Spotify", level: "admin" },
  { user: "Priyanka", app: "Amazon", level: "admin" },
  { user: "Priyanka", app: "Facebook", level: "admin" },
  { user: "Priyanka", app: "Gmail", level: "admin" },
  { user: "Ramya", app: "Instagram", level: "admin" },
  { user: "Ramya", app: "Twitter", level: "admin" },
  { user: "Sandeep", app: "Netflix", level: "user" },
  { user: "Sandeep", app: "Twitter", level: "admin" },
  { user: "Shireesha", app: "Facebook", level: "admin" },
  { user: "Shireesha", app: "Netflix", level: "admin" },
  { user: "Shireesha", app: "Twitter", level: "user" },
  { user: "Shiva", app: "Facebook", level: "admin" },
  { user: "Shivathmika", app: "Google Maps", level: "user" },
  { user: "Sriram", app: "Amazon", level: "user" },
  { user: "Sriram", app: "Instagram", level: "user" },
  { user: "Sriram", app: "Netflix", level: "user" },
  { user: "Subhash", app: "YouTube", level: "user" },
  { user: "Thomas Scott", app: "Facebook", level: "admin" },
  { user: "Thomas Scott", app: "Twitter", level: "user" },
  { user: "Thomas Scott", app: "YouTube", level: "user" },
  { user: "Vinay", app: "Amazon", level: "admin" },
  { user: "Vinay", app: "Netflix", level: "admin" },
  { user: "Vinay", app: "Spotify", level: "user" }
]

# Create Permissions
permissions_data.each do |p|
  Permission.create!(
    user: users[p[:user]],
    application: applications[p[:app]],
    can_read: true,
    can_write: p[:level] == "admin" || p[:level] == "user",
    can_delete: p[:level] == "admin"
  )
end

# Update user roles based on permissions
User.find_each do |user|
  if user.permissions.exists?(can_delete: true)
    user.update!(role: :admin)
  else
    user.update!(role: :user)
  end
end

puts "Seed completed: #{User.count} users, #{Application.count} apps, #{Permission.count} permissions."


