#!/usr/bin/env ruby

require 'rubygems'
require 'dogapi'
require 'jsonl'
require 'time'

api_key = ENV["DD_API_KEY"]
$dog = Dogapi::Client.new(api_key)

$i = 0

def send_metrics(points)
  $dog.emit_points('tilt.updates', points, :tags => {user: 'dmiller'}, :type => 'gauge')
end

def adjust_timestamp(time)
  $i = $i + 1
  new_t = Time.now - $i * 60
  puts new_t
  new_t
end

raw_json = ARGF.read
parsed_json = JSONL.parse(raw_json)

points = parsed_json.map { |j| [adjust_timestamp(Time.parse(j["StartTime"])), 1] }
send_metrics(points)
