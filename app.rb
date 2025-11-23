# frozen_string_literal: true

class App
  def initialize
    @redis = Redis.new(url: ENV['REDIS_URL'])
    @redis.set('counter', 0) unless @redis.get('counter')
  end

  def call(env)
    req = Rack::Request.new(env)

    case [req.request_method, req.path_info]
    when ['GET', '/counter'] then counter
    when ['POST', '/increment'] then increment
    else not_found
    end
  end

  private

  attr_reader :redis

  def counter = reply(redis.get('counter'))

  def increment = reply(redis.incr('counter'))

  def reply(value) = [200, { 'content-type' => 'text/html' }, ["[#{ENV.fetch('ENV_ID', 'none')}] Counter: #{value.to_i + 100}"]]

  def not_found = [404, { 'content-type' => 'text/plain' }, ['Not found']]
end
