class Participant < ActiveRecord::Base
  belongs_to :game
  belongs_to :team
  belongs_to :spell1, class_name: 'StaticData::SummonerSpell'
  belongs_to :spell2, class_name: 'StaticData::SummonerSpell'
  belongs_to :champion, :class_name => 'StaticData::Champion'
  has_many :mastery_points, dependent: :destroy
  has_many :rune_points, dependent: :destroy
  has_and_belongs_to_many :events
  enum highestAchievedSeasonTier: [ :CHALLENGER, :MASTER, :DIAMOND, :PLATINUM, :GOLD, :SILVER, :BRONZE, :UNRANKED]
  #attr_accessible :, :participantId

  def self.build_from_array array, game
    res = []
    array.each do |json|
      res.append build_from_json(json, game)
    end
    res
  end

  def self.build_from_json json, game
    p = json.select{|k, v| atomic_attributes.include? k}
    p['spell1'] = StaticData::SummonerSpell.find_or_build_by_id(json['spell1Id'])
    p['spell2'] = StaticData::SummonerSpell.find_or_build_by_id(json['spell2Id'])
    p['champion'] = StaticData::Champion.find_or_build_by_id(json['championId'])
    p['team_id'] = json['teamId'] == 100 ? game.blue_team_id : game.red_team_id
    #p['mastery_points'] = MasteryPoint.build_from_array(json['masteries']) if json['masteries']
    #p['rune_points'] = RunePoint.build_from_array(json['runes']) if json['runes']
    create(p)
  end

  def self.atomic_attributes
    ["participantId", "highestAchievedSeasonTier"]
  end

  def to_hash
    {participantId: participantId,
    champion: champion.as_json(include: :image),
    hierAchievedSeasonTier: highestAchievedSeasonTier,
    spell1: spell1.as_json(include: :image),
    spell2: spell2.as_json(include: :image),
    level: 0,
    kills: 0,
    deaths: 0,
    assists: 0,
    items: [],
    trinket: nil,
    brawler:
        {type: nil,
        evolve: nil},
    gold: 0}
  end

  private_class_method :atomic_attributes
end
