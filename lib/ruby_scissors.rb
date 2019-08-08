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

module RubyScissors
  class Scissors
    attr_reader :fodder
    def initialize(fodder)
      @fodder = fodder
    end

    def reverse_words
      get_words.reverse.join(' ')
    end

    def reverse_lines(cpl = pick_cpl)
      get_lines(cpl).reverse.join('').strip
    end

    def shuffle_words(shuffler = nil)
      shuffled = []
      if shuffler
        shuffled = shuffler.call(get_words)
      else
        shuffled = get_words.shuffle
      end
      shuffled.join(' ')
    end

    def shuffle_lines(opts={})
      shuffler = opts[:shuffler]
      cpl = opts[:cpl] || pick_cpl
      shuffled = []
      if shuffler
        shuffled = shuffler.call(get_lines(cpl))
      else
        shuffled = get_lines(cpl).shuffle
      end
      shuffled.join('').strip
    end

    def burr_split(opts={})
      shuffler = opts[:shuffler] || default_shuffler
      cpl = opts[:cpl] || pick_cpl

      half_lines = get_half_lines(cpl)

      burroughs(half_lines, shuffler: shuffler, cpl: cpl)
    end

    def burr_word(opts={})
      shuffler = opts[:shuffler] || default_shuffler
      cpl = opts[:cpl] || pick_cpl

      half_lines = get_half_lines_around_words(cpl)

      burroughs(half_lines, shuffler: shuffler, cpl: cpl)
    end

    private

    def default_shuffler
      lambda do |array|
        array.shuffle
      end
    end

    def pick_cpl
      (35..95).to_a.sample
    end

    def get_words
      fodder.split(/ /)
    end

    def get_lines(cpl = pick_cpl)
      lines = []
      split_string_arr = get_words

      until (split_string_arr.empty?)
        line = ""
        while (line.length <= cpl)
          if (split_string_arr.empty?)
            line += ' '
          else
            line += split_string_arr.shift + ' '
          end
        end
        lines.push(line)
      end
      lines
    end

    def get_half_lines(cpl = pick_cpl)
      half_lines = []

      get_lines(cpl).each do |line|
        midpoint = (line.length / 2.0).ceil
        first = line.slice(0..midpoint-1)
        second = line.slice(midpoint..line.length)

        half_lines.push(first, second)
      end

      half_lines
    end

    def get_half_lines_around_words(cpl = pick_cpl)
      half_lines = []

      get_lines(cpl).each do |line|
        split_line = line.split(/ /)
        midpoint = (split_line.length / 2.0).ceil
        first_arr = split_line.slice(0...midpoint)
        second_arr = split_line.slice(midpoint, split_line.length)
        first = first_arr.join(' ') + ' '
        second = second_arr.join(' ') + ' '

        half_lines.push(first, second)
      end

      half_lines
    end

    def get_quarter_lines(half_lines)
      first_half = []
      second_half = []

      until (half_lines.empty?)
        first_half.push(half_lines.shift)
        if (half_lines[0])
          second_half.push(half_lines.shift)
        end
      end

      first_half_mid = (first_half.length / 2.0).floor
      second_half_mid = (second_half.length / 2.0).floor

      first_quarter = first_half[0..first_half_mid-1]
      second_quarter = second_half[0..second_half_mid-1]
      third_quarter = first_half[first_half_mid..first_half.length]
      fourth_quarter = second_half[second_half_mid..second_half.length]

      [first_quarter, second_quarter, third_quarter, fourth_quarter]
    end

    def burroughs(half_lines, opts={})
      shuffler = opts[:shuffler] || default_shuffler
      cpl = opts[:cpl] || pick_cpl

      shuffled_quarters = shuffler.call(get_quarter_lines(half_lines))
      top = shuffled_quarters[0].zip(shuffled_quarters[1]).flatten.compact
      bottom = shuffled_quarters[2].zip(shuffled_quarters[3]).flatten.compact
      (top + bottom).join('').strip
    end
  end
end
