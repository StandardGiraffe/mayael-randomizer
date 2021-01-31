class Deck
  attr_reader :cards

  def initialize(base: nil, basic_land_slots: 0, timestamp:)
    @timestamp = timestamp

    @cards = parse_deck_file(base) || [ ]
    @basic_land_slots = basic_land_slots

    @creature_mana_distribution = {
      white: 0,
      red: 0,
      green: 0
    }

    ensure_mayael_exists!
  end

  def slots_available_for_creatures
    100 - cards_in_deck - @basic_land_slots
  end

  def add_creature!(creature)
    tally_creature_mana_cost!(creature["mana_cost"])

    add_card!(name: creature["name"])
  end

  def add_basic_lands!
    total_coloured_mana = @creature_mana_distribution.values.sum.to_f

    {
      white: "Plains",
      red: "Mountain",
      green: "Forest"
    }.each do |colour, land|
      quantity = unless land == "Forest"
          ((@creature_mana_distribution[colour] / total_coloured_mana) * @basic_land_slots).floor
        else
          slots_available
        end

      add_card!(
        name: land,
        quantity: quantity
      )
    end
  end

  def deck_string
    contents = @cards.sort { |a, b| a.name <=> b.name }.map do |card|
      "        <card number=\"#{card.quantity}\" name=\"#{card.name}\"/>\n"
    end

    output = <<~OUTPUT
    <?xml version="1.0" encoding="UTF-8"?>
    <cockatrice_deck version="1">
        <deckname>Mayael Randomizer (#{@timestamp})</deckname>
        <comments>This deck was produced by Danny Fekete's "Mayael Randomizer" app.  Hope it's not terrible!</comments>
        <zone name="main">\n#{contents.join}
        </zone>
    </cockatrice_deck>
    OUTPUT
  end

private
  def ensure_mayael_exists!
    unless @cards.find { |c| c.name == "Mayael the Anima" }
      add_card!(name: "Mayael the Anima")
    end
  end

  def parse_deck_file(deck_file)
    return unless deck_file

    (open deck_file).readlines.map(&:strip).select do |line|
      line.match?(/<card number=/)
    end.map do |line|
      Card.new(card_line: line)
    end
  end

  def cards_in_deck
    @cards.sum { |card| card.quantity }
  end

  def slots_available
    100 - cards_in_deck
  end

  def add_card!(name:, quantity: 1)
    if card = @cards.find { |c| c.name == name }
      card.quantity += quantity
    else
      @cards << Card.new(
        name: name,
        quantity: quantity
      )
    end
  end

  def tally_creature_mana_cost!(mana_cost)
    @creature_mana_distribution[:white] += mana_cost&.count("W")
    @creature_mana_distribution[:red] += mana_cost&.count("R")
    @creature_mana_distribution[:green] += mana_cost&.count("G")
  end
end

require_relative "./deck/card"
