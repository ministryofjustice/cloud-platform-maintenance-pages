#!/usr/bin/env ruby

require "bundler/setup"
require "sinatra"
require "sinatra/content_for"

get "*" do
  erb request.host.to_sym
end
