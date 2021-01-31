require 'mtg-db'
require 'yaml'

all_cards = Mtg::Db.cards

pool = all_cards.select do |card|
  card["power"] && card["power"].to_i >= 5
end.reject do |card|
  card["mana_cost"]&.match?(/B/) || card["mana_cost"]&.match?(/U/) || card["oracle_text"][0]&.match(/{U}/) || card["oracle_text"][0]&.match(/{B}/) || card["oracle_text"][0]&.match(/{BP}/) || card["oracle_text"][0]&.match(/{UP}/) || card["oracle_text"][0]&.match(/{2\/U}/) || card["oracle_text"][0]&.match(/{2\/B}/) || !card["mana_cost"]
end.uniq do |card|
  card["name"]
end

File.open("../db/pool.yml", 'w') do |file|
  file.write(pool.to_yaml)
end
