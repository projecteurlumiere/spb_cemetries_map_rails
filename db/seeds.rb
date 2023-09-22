# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# - Найти список кладбищ (в идеале array из названий получить. Или можно запарсить страничку в википедии)
# - На каждый раз выдать запрос в OSM, чтобы получить osm_id (не забыть, что у каждого есть type и надо его поставить рядом с id)
# - Вывести название и координаты (координаты должны быть в JSON или GeoJSON) на итоговую карту

require 'net/http'

# getting the list of cemeteries from a parsed webpage

def fetch_list_of_cemeteries(url, css_filter)
  node_list = Net::HTTP.get(URI(url))

  Nokogiri::HTML.parse(node_list).css(css_filter).each_with_object([]) do |tag, array|
    tag.children.each do |child_tag|
      next if child_tag.attribute('alt').nil?
      array << child_tag.attribute('alt').value
    end
  end.uniq
end

# getting a hash of geojson polygons for each cemetery from osm nominatim api
# block is for name filtering

def fetch_polygons_hash(cemeteries_array, &block)
  cemeteries_array.each_with_object({}) do |cemetery_name, hash|
    cemetery = block.call(cemetery_name)

    osm_type_id = fetch_osm_type_id(cemetery)

    coordinates = if osm_type_id.nil?
      nil
    else
      fetch_osm_polygon(osm_type_id)
    end

    hash[cemetery] = { coordinates_geo_json: coordinates }
  end
end

def fetch_osm_type_id(cemetery_name)
  response = Net::HTTP.get(URI.parse(URI::Parser.new.escape("https://nominatim.openstreetmap.org/search?q=#{cemetery_name} Санкт-Петербург&format=json&limit=1")))
  parsed_response = JSON.parse(response)

  if parsed_response.empty?
    puts "id not found for #{cemetery_name}"
    nil
  else
    puts "id found for #{cemetery_name}"
    parsed_response[0]['osm_type'][0].capitalize.concat(parsed_response[0]['osm_id'].to_s)
  end
end

def fetch_osm_polygon(osm_type_id)
  response = Net::HTTP.get(URI("https://nominatim.openstreetmap.org/lookup?osm_ids=#{osm_type_id}&format=json&polygon_geojson=1"))

  parsed_response = JSON.parse(response)

  JSON.dump(parsed_response[0]['geojson']) unless parsed_response.empty? # was nil? before
end

def create_cemetery(name = Faker::Travel::TrainStation.name, coordinates_geo_json = nil)
  Cemetery.create(
    name: name,
    year_opened: Faker::Date.between(from: '1800-01-01', to: '1899-12-31'),
    year_closed: Faker::Date.between(from: '1900-01-01', to: '1939-09-01'),
    description: Faker::Lorem.paragraph(sentence_count: 20),
    main_pic_link: FFaker::Image.url,
    main_thumb_pic_link: FFaker::Image.url('150x150'),
    coordinates_geo_json: coordinates_geo_json
  )
end

def quasi_random_n_of_photos(index)
  case index
  when 0
    5
  when 1
    10
  when 2
    1
  when 3
    0
  when 4
    3
  else
    (1..10).to_a.sample
  end
end

def create_mitro_cemetery
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
]".gsub(/\R+/, '').squeeze.concat("]")

  Cemetery.create(
    name: "Митрофаньевское кладбище",
    year_opened: Faker::Date.between(from: '1800-01-01', to: '1899-12-31'),
    year_closed: Faker::Date.between(from: '1900-01-01', to: '1939-09-01'),
    description: Faker::Lorem.paragraph(sentence_count: 20),
    coordinates: mitro_coordinates,
    main_pic_link: FFaker::Image.url,
    main_thumb_pic_link: FFaker::Image.url('150x150')
  )
end

# beginning:

url = 'https://spb.ritual.ru/poleznaya-informatsiya/kladbishcha/'
css_filter = 'div.flat-grid > div.flat-grid__block > div.flat-grid__list'

cemeteries_array = fetch_list_of_cemeteries(url, css_filter)

cemeteries_hash = fetch_polygons_hash(cemeteries_array) do |cemetery_name|
  unless cemetery_name.downcase.include?('кладбище')
    cemetery_name = 'Кладбище '.concat(cemetery_name)
  end

  if cemetery_name.downcase.include?('девятого')
    cemetery_name = cemetery_name.sub('Девятого', '9')
  end
  cemetery_name
end

create_mitro_cemetery

cemeteries_hash.each do |name, hash|
  create_cemetery(name, hash[:coordinates_geo_json])
end

Cemetery.all.each_with_index do |cemetery, index|
  n = quasi_random_n_of_photos(index)
  n.times do
    Photo.create(
      cemetery_id: cemetery.id,
      link: FFaker::Image.url,
      thumb_link: FFaker::Image.url('150x150'),
      name: Faker::Lorem.sentence(word_count: 3),
      description: Faker::Lorem.paragraph(sentence_count: 3)
    )
  end
end