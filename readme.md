# Mayael the Anima Randomizer for [Cockatrice](https://cockatrice.github.io/)

![Mayael the Anima](https://c1.scryfall.com/file/scryfall-cards/normal/front/3/0/309d95ad-e46c-4407-894d-d4cfdc7017f8.jpg?1562905228 "Mayael the Anima")

This silly Ruby program builds Cockatrice commander deck featuring [Mayael the Anima](https://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=376407) and a random selection of creatures matching the WRG colour signature with five or greater power.

Fun Features:
* Basic lands will be added that support the distribution of mana costs in the selected creatures
* A pre-built base deck can (and probably *should*) be specified; creatures and additional mana will be slotted in
* A variety of filters are available for configuration to modify the pool of available creatures
* A script is included to produce an updated pool when subsequent sets are released

## Usage

1. Clone this repository and install the [MTG Database Gem](https://github.com/sgtFloyd/mtg-db):

  ```terminal
  .../mayael-randomizer$ git clone ...
  .../mayael-randomizer$ bundle install
  ```

2. Rename or copy `config.yml.template` to `config.yml`:

  ```terminal
  .../mayael-randomizer$ cp config.yml.template config.yml
  ```

3. *Optionally,* re-dump the creature pool YAML:

  ```terminal
  .../mayael-randomizer$ cd bin
  .../mayael-randomizer/bin$ ruby dump_creature_pool.rb
  ```

4. Configure `config.yml`:
   * Specify the **`base_deck`** path if you wish to start with a partially-complete deck.  This must be a Cockatrice `.cod` file.
   * Specify the **`output_directory`** for the finished deck.
   * Specify the integer number of **`basic_land_slots`**.  If using a base deck with some lands already included, this number should be (total desired number of lands) - (included lands); otherwise, specify the total desired number of lands (37 is usually reasonable).
   * Specify the absolute **`pool_yaml`** path to `pool.ym`.  This is normally found in `./mayael-randomizer/bin`.

5. *Optionally,* configure filters in `config.yml`:
   * You may **`remove_rarities`** from the creature pools as an array of `Common`, `Uncommon`, `Rare`, and `Mythic Rare`
   * You may all **`remove_eldrazi`** from the pool by setting this to `true`
   * You may all **`remove_unsets`** from the pool by setting this to `true` (*Unglued*, *Unhinged*, *Unstable*, and *Unsanctioned* cards will currently be removed)
   * You may exclude a list of specific creatures as an array creature names within **`remove_creatures`**

6. Finally, run `main.rb` to generate your deck:
   ```terminal
   .../mayael-randomizer$ ruby main.rb
   #=> CREATED: <configured output path>/Mayael Randomizer 1612070107.cod
   ```

## Play Suggestions

### Mayael Monster Mash:

* Use this randomizer on a small base deck including ramp and a few Mayael commander staples to create about twenty decks
* Share the decks with your pod and have everyone play a randomly chosen deck in a four-way beat-em-up
* Profit?

## Closing Notes
Suggestions and requests are always welcome, but please bear in mind that I initially wrote this as a weekend project and don't expect to support it actively.  Nonetheless, if you find it fun, I'd be delighted to hear about it!
