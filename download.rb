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

def download_if_updated(url, path)
  if last_modified_time(path) < last_modified_time(url)
    download url, path

    # 다른 프로그램에서 확인하기 위해 다운로드 했을 때 출력
    puts "#{path} downloaded"
  end
end

if __FILE__ == $0
  require "#{File.expand_path(File.dirname(__FILE__))}/environment"
  download_if_updated(ENV['dict_url'], ENV['dict_path'])
  download_if_updated(ENV['synonym_url'], ENV['synonym_path'])
end
