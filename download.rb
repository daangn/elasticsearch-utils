#!/usr/bin/env ruby
require 'net/http'
require 'time'

def last_modified_time(url)
  uri = URI(url)
  path = uri.path

  if uri.scheme.nil?
    return Time.at(0) unless File.exists?(path)
    return File.mtime(path)
  end

  time_str = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
    response = http.head(path)
    response['Last-Modified']
  end
  Time.parse time_str
end

def download(url, path)
  `curl -o #{path} #{url}`
end

if __FILE__ == $0
  require './environment'
  url = ENV['dict_url']
  path = ENV['dict_path']

  if last_modified_time(path) < last_modified_time(url)
    download url, path
  end
end
