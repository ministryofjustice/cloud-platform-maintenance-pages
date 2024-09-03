#!/usr/bin/env ruby

require "bundler/setup"
require "sinatra"
require "sinatra/content_for"

set :environment, :production

use Rack::Protection
use Rack::Protection::FrameOptions
use Rack::Protection::ContentSecurityPolicy, 
  default_src: "'self' 'unsafe-inline' data: https://region1.google-analytics.com https://www.googletagmanager.com",
use Rack::Protection::XSSHeader
use Rack::Protection::StrictTransport

get "*" do
  erb request.host.to_sym
end
