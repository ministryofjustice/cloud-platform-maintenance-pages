#!/usr/bin/env ruby

require "bundler/setup"
require "sinatra"
require "sinatra/content_for"

set :environment, :production

get "*" do
  erb request.host.to_sym
end
