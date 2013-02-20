class Round < ActiveRecord::Base
  has_many :matches
  belongs_to :event
  attr_accessible :event_id, :number


  def create_matches
    return if matches.length > 0

    ranked_players = event.rank_players

    to_be_paired = ranked_players.dup

    while (to_be_paired.length >1)
      p = to_be_paired[0][0]
      opponent_offset = 0
      begin
        opponent_offset += 1
        # this will raise if we get past the end of tbp without finding an unmatched opponent
        opponent = to_be_paired[opponent_offset][0]
      end while p.has_been_paired?(opponent)

      matches.create!(:player_1=>p, :player_2=>opponent)
      to_be_paired.delete_at(opponent_offset)
      to_be_paired.delete_at(0)
    end
  end

      

end
