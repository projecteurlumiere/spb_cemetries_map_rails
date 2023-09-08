# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

def create_cemetry 
  Cemetery.create(
    name: Faker::Travel::TrainStation.name,
    year_opened: Faker::Date.between(from: '1800-01-01', to: '1899-12-31'),
    year_closed: Faker::Date.between(from: '1900-01-01', to: '1939-09-01'),
    description: Faker::Lorem.paragraph(sentence_count: 20),
  )
end

mitro_coordinates = "[
  [59.896563, 30.310181],
  [59.891538, 30.310439],
  [59.890580, 30.306039],
  [59.891473, 30.305567],
  [59.891075, 30.301725],
  [59.892431, 30.301210],
  [59.892689, 30.303485],
  [59.893260, 30.303271],
  [59.893077, 30.300996],
  [59.893787, 30.300738],
  [59.893906, 30.302026],
  [59.894132, 30.301983],
  [59.894164, 30.302562],
  [59.894648, 30.302476],
  [59.894627, 30.300416],
  [59.894627, 30.300416],
  [59.894498, 30.297712],
  [59.896155, 30.297090],
  [59.896219, 30.297347],
  [59.896499, 30.297347],
  [59.896478, 30.296875],
  [59.898490, 30.297218],
  [59.898738, 30.298914],
  [59.898576, 30.298978],
  [59.898835, 30.301554],
  [59.896532, 30.303163]
]".gsub(/\R+/, '').squeeze

Cemetery.create(
  name: "Mitrofaniyevskoe Kladbische",
  year_opened: Faker::Date.between(from: '1800-01-01', to: '1899-12-31'),
  year_closed: Faker::Date.between(from: '1900-01-01', to: '1939-09-01'),
  description: Faker::Lorem.paragraph(sentence_count: 20),
  coordinates: mitro_coordinates
)

10.times do 
  Cemetery.create(
    name: Faker::Travel::TrainStation.name,
    year_opened: Faker::Date.between(from: '1800-01-01', to: '1899-12-31'),
    year_closed: Faker::Date.between(from: '1900-01-01', to: '1939-09-01'),
    description: Faker::Lorem.paragraph(sentence_count: 30),
  )
end

Cemetery.all.each do |cemetery|
  5.times do 
    Photo.create(
      cemetery_id: cemetery.id,
      link: FFaker::Image.url,
      name: Faker::Lorem.sentence(word_count: 3),
      description: Faker::Lorem.paragraph(sentence_count: 3)
    )
  end
end