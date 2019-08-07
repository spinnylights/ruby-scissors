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

require 'ruby_scissors/version'

Gem::Specification.new do |s|
  s.name          = 'ruby_scissors'
  s.summary       = 'A tool and library for making literary cut-ups.'
  s.description   = <<-desc
    RubyScissors is a tool and library for cutting up text, taking inspiration from the techniques of William Burroughs/Byron Gysin and Tristan Tzara. It is a port of a JavaScript library, Scissors.js, by the same author.
  desc
  s.version       = RubyScissors::VERSION
  s.author        = 'Zoë Sparks'
  s.email         = 'zoe@milky.flowers'
  s.homepage      = 'https://github.com/spinnylights/ruby_scissors'
  s.license       = 'GPL-3.0-or-later'
  s.required_ruby_version = '>= 1.9.2'
  s.files         = `git ls-files`.split
  s.require_paths = ['lib']
end
