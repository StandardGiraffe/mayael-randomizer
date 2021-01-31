require 'mtg-db'
require 'yaml'
require_relative 'deck'

config = YAML.load_file("config.yml")
creatures = YAML.load_file(config["pool_yaml"])
timestamp = Time.now.to_i


# Apply filters to the creature pool
filters = config["filters"]

if filters["remove_rarities"].any?
  creatures.reject! do |creature|
    filters["remove_rarities"].include?(creature["rarity"])
  end
end

if filters["no_eldrazi"]
  creatures.reject! do |creature|
    creature["subtypes"]&.include?("Eldrazi")
  end
end

if filters["remove_unsets"]
  creatures.reject! do |creature|
    creature["set_name"].match?(/\AUn/)
  end
end

if filters["remove_creatures"].any?
  creatures.reject! do |creature|
    filters["remove_creatures"].include?(creature["name"])
  end
end


# Build the deck
deck = Deck.new(
  base: config["base_deck"] ? (open config["base_deck"]) : nil,
  basic_land_slots: config["basic_land_slots"],
  timestamp: timestamp
)

creatures.sample(deck.slots_available_for_creatures).each do |creature|
  deck.add_creature!(creature)
end

deck.add_basic_lands!


# Create the Cockatrice deck file
File.open("#{config["output_directory"]}/Mayael Randomizer #{timestamp}.cod", 'w') do |file|
  file.write(deck.deck_string)
end && puts("CREATED: #{config["output_directory"]}Mayael Randomizer #{timestamp}.cod")

