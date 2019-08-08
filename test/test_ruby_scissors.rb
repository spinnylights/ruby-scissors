# encoding: utf-8
# frozen_string_literal: true

# Copyright 2019 Zoë Gold Sparks <zoe@milky.flowers>
#
# This file is part of RubyScissors.
#
# RubyScissors is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# RubyScissors is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with RubyScissors.  If not, see <https://www.gnu.org/licenses/>.

require 'minitest/autorun'
require 'ruby_scissors'

class TestRubyScissors < MiniTest::Unit::TestCase
  def setup
    fodder = "In certain lights that mark on the wall seems actually to " \
             "project from the wall. Nor is it entirely circular. I cannot " \
             "be sure, but it seems to cast a perceptible shadow, suggesting " \
             "that if I ran my finger down that strip of the wall it would, " \
             "at a certain point, mount and descend a small tumuls, a " \
             "smooth tumulus like those barrows on the South Downs which " \
             "are, they say, either tombs or camps. Of the two I should " \
             "prefer them to be tombs, desiring melancholy like most " \
             "English people, and finding it natural at the end of a walk " \
             "to think of the bones stretched beneath the turf..."
    @scissors = RubyScissors::Scissors.new(fodder)

    @burr_shuffler = lambda do |parts|
      shuffled_parts = []

      shuffled_parts[0] = parts[1]
      shuffled_parts[1] = parts[0]
      shuffled_parts[2] = parts[3]
      shuffled_parts[3] = parts[2]

      shuffled_parts
    end

    @shuffle_shuffler = lambda do |parts|
      shuffled_parts = []
      random_indices = [
        93, 57, 68, 10, 70, 17, 77, 84, 42, 38, 37, 89, 101, 6, 91, 78, 50, 58,
        60, 53, 96, 103, 16, 13, 11, 106, 83, 80, 24, 21, 31, 52, 107, 94, 73,
        29, 59, 62, 66, 79, 27, 36, 76, 47, 71, 45, 25, 14, 56, 85, 86, 92,
        108, 90, 51, 82, 88, 3, 48, 5, 102, 100, 20, 33, 44, 4, 69, 2, 99, 97,
        49, 74, 1, 81, 7, 8, 39, 0, 35, 75, 43, 98, 55, 34, 63, 22, 105, 46,
        64, 19, 40, 26, 18, 30, 23, 95, 72, 12, 67, 41, 54, 15, 32, 65, 87,
        28, 9, 104, 61, 109
      ]

      random_indices.each_with_index {|i, n| shuffled_parts[n] = parts[i]}

      shuffled_parts
    end

    @cpl = 60
  end

  # Burroughs

  def test_burr_split_simulates_cutting_into_squares_through_words
    expected = "e wall seems actually to project In certain lights that " \
               "mark on thly circular. I cannot be sure, from the wall. Nor " \
               "is it entireble shadow, suggesting that if but it seems to " \
               "cast a percepti the wall it would, at a certain I ran my " \
               "finger down that strip of tumuls, a smooth tumulus like " \
               "point, mount and descend a smalls which are, they say, " \
               "either those barrows on the South Downould prefer them to " \
               "be tombs, tombs or camps. Of the two I shnglish people, " \
               "and finding it desiring melancholy like most E think of the " \
               "bones stretched natural at the end of a walk to             " \
               "                 beneath the turf..."

    cut_up = @scissors.burr_split(cpl: @cpl, shuffler: @burr_shuffler)

    assert_equal(expected, cut_up)
  end

  def test_burr_word_simulates_cutting_into_squares_around_words
    expected = "the wall seems actually to project In certain lights that " \
               "mark on entirely circular. I cannot be sure, from the wall. " \
               "Nor is it perceptible shadow, suggesting that if but it " \
               "seems to cast a the wall it would, at a certain I ran my " \
               "finger down that strip of tumuls, a smooth tumulus like " \
               "point, mount and descend a small which are, they say, either " \
               "those barrows on the South Downs should prefer them to be " \
               "tombs, tombs or camps. Of the two I people, and finding it " \
               "desiring melancholy like most English to think of the bones " \
               "stretched natural at the end of a walk turf... beneath the"

    cut_up = @scissors.burr_word(cpl: @cpl, shuffler: @burr_shuffler)

    assert_equal(expected, cut_up)
  end

  # Reverse

  def test_reverse_words_puts_words_in_opposite_order
    expected = "turf... the beneath stretched bones the of think to walk a " \
               "of end the at natural it finding and people, English most " \
               "like melancholy desiring tombs, be to them prefer should I " \
               "two the Of camps. or tombs either say, they are, which " \
               "Downs South the on barrows those like tumulus smooth a " \
               "tumuls, small a descend and mount point, certain a at " \
               "would, it wall the of strip that down finger my ran I if " \
               "that suggesting shadow, perceptible a cast to seems it but " \
               "sure, be cannot I circular. entirely it is Nor wall. the " \
               "from project to actually seems wall the on mark that lights " \
               "certain In"

    cut_up = @scissors.reverse_words

    assert_equal(cut_up, expected)
  end

  def test_reverse_lines_splits_into_lines_and_reverses_them
    expected = "of the bones stretched beneath the turf...              " \
               "people, and finding it natural at the end of a walk to " \
               "think prefer them to be tombs, desiring melancholy like " \
               "most English are, they say, either tombs or camps. Of the " \
               "two I should smooth tumulus like those barrows on the South " \
               "Downs which at a certain point, mount and descend a small " \
               "tumuls, a that if I ran my finger down that strip of the " \
               "wall it would, be sure, but it seems to cast a perceptible " \
               "shadow, suggesting project from the wall. Nor is it " \
               "entirely circular. I cannot In certain lights that mark on " \
               "the wall seems actually to"

    cut_up = @scissors.reverse_lines(55)

    assert_equal(cut_up, expected)
  end

  # Shuffle

  def test_shuffle_words_randomizes_word_order
    expected = "it a are, to say, it two tombs, of finger my English to the " \
               "and I point, smooth like descend the of is the project " \
               "stretched be prefer but cannot shadow, and beneath natural " \
               "or a tumulus barrows Downs should to ran the at either it it " \
               "wall. tumuls, desiring melancholy finding the people, mount " \
               "to most that a on think walk I that wall mark they lights a " \
               "end certain camps. certain them wall seems down In I Of the " \
               "of small if on be bones would, the circular. that seems " \
               "entirely perceptible sure, at tombs from which strip a Nor " \
               "suggesting South like cast actually the those turf..."

    cut_up = @scissors.shuffle_words(@shuffle_shuffler)

    assert_equal(cut_up, expected)
  end

  def test_shuffle_words_returns_string_with_default_shuffle
    assert_kind_of(String, @scissors.shuffle_words)
  end

  def test_shuffle_lines_splits_into_lines_and_randomizes_their_order
    expected = "tombs or camps. Of the two I should prefer them to be tombs, " \
               "I ran my finger down that strip of the wall it would, at a " \
               "certain those barrows on the South Downs which are, they " \
               "say, either point, mount and descend a small tumuls, a " \
               "smooth tumulus like but it seems to cast a perceptible " \
               "shadow, suggesting that if from the wall. Nor is it entirely " \
               "circular. I cannot be sure, desiring melancholy like most " \
               "English people, and finding it natural at the end of a walk " \
               "to think of the bones stretched In certain lights that mark " \
               "on the wall seems actually to project beneath the turf..."

    cut_up = @scissors.shuffle_lines(shuffler: @shuffle_shuffler, cpl: 60)

    assert_equal(cut_up, expected)
  end

  def test_shuffle_lines_returns_string_with_default_shuffle
    assert_kind_of(String, @scissors.shuffle_lines)
  end
end
