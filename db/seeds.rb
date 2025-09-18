Application.destroy_all

applications = [
  { name: "Social Networking ", description: "Connects people and allows sharing content." },
  { name: "Music Streaming ", description: "Stream and discover music online." },
  { name: "Library Management ", description: "Manages library books and members." },
  { name: "Car Rental ", description: "Allows users to rent cars online." },
  { name: "Event Booking ", description: "Facilitates booking and managing events." }
]

applications.each do |app|
  Application.create!(app)
end

puts "Seeded #{Application.count} applications successfully!"

