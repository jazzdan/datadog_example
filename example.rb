#!/usr/bin/env ruby

require 'rubygems'
require 'dogapi'
require 'jsonl'
require 'time'

api_key = ENV["DD_API_KEY"]
$dog = Dogapi::Client.new(api_key)

def send_metrics(points)
  # TODO(dmiller): does this tags parameter work?
  $dog.emit_points('tilt.updates', points, :tags => {})
end

raw_json = ARGF.read
parsed_json = JSONL.parse(raw_json)

#TODO(dmiller): do I need to massage these timestamps to that they are at most an hour ago?
points = parsed_json.map { |j| [Time.parse(j["StartTime"]), 1] }
send_metrics(points)
