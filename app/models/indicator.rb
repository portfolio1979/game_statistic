class Indicator < ApplicationRecord
  belongs_to :player, optional: true
  belongs_to :game, optional: true
  belongs_to :target_indicator, class_name: 'Indicator', optional: true
  validates :kind, presence: true

  scope :target, ->{where(kind: 'target')}
  scope :player, ->{where(kind: 'player')}

  def top_players(count: 5, scope: :all)
    if scope.is_a? Command
      players = scope.players.includes(:indicators).references(:indicators)
    else
      players = Player.includes(:indicators).references(:indicators)
    end
    sorted(players, count)
  end

  def sorted(players, count)
    players.sort { |a, b| a.indicators.count <=> b.indicators.count }.reverse.first(count)
  end
end
