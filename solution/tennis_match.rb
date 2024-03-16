#!/usr/bin/ruby

class TennisMatch
  attr_reader :players

  GAME_SCORES = { 0 => 0, 1 => 15, 2 => 30, 3 => 40 }.freeze

  def initialize(player1, player2)
    @players = {
      player1 => { set_score: 0, game_score: 0 },
      player2 => { set_score: 0, game_score: 0 }
    }
  end

  def score
    "#{set_score_string}, #{game_score_string}"
  end

  def point_won_by(player_name)
    raise ArgumentError, 'Invalid player name' unless @players.key?(player_name)

    player = @players[player_name]
    player[:game_score] += 1

    update_set_score if game_won?
  end

  private

  def game_won?
    @players.values.any? { |player| player[:game_score] >= 4 && (player[:game_score] - @players.values[1][:game_score]).abs >= 2 }
  end

  def update_set_score
    winner = @players.values.max_by { |player| player[:game_score] }
    winner[:set_score] += 1
    reset_game_scores
  end

  def set_score_string
    @players.map { |player, scores| "#{player}: #{scores[:set_score]}" }.join('-')
  end

  def game_score_string
    player1_score = GAME_SCORES[@players.values[0][:game_score]]
    player2_score = GAME_SCORES[@players.values[1][:game_score]]

    if player1_score == player2_score
      player1_score >= 40 ? 'Deuce' : "#{player1_score}-All"
    elsif player1_score >= 40 || player2_score >= 40
      (player1_score - player2_score).abs == 1 ? "Advantage #{advantage_player}" : "Game #{advantage_player}"
    else
      "#{player1_score}-#{player2_score}"
    end
  end

  def advantage_player
    @players.key(@players.values.max_by { |player| player[:game_score] })
  end

  def reset_game_scores
    @players.each { |_player, scores| scores[:game_score] = 0 }
  end
end