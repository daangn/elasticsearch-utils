#!/usr/bin/env ruby
require 'net/http'
require 'time'

def file_info(url)
  uri = URI(url)
  path = uri.path

  if uri.scheme.nil?
    return Time.at(0) unless File.exists?(path)
    return {mtime: File.mtime(path), size: File.size(path)}
  end

  info = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
    response = http.head(path)
    {mtime: response['Last-Modified'], size: response['Content-Length'].to_i}
  end
  info[:mtime] = Time.parse info[:mtime]
  info
end

def download(url, path)
  `curl -o #{path} #{url}`
end

def download_if_updated(url, path)
  local_info = file_info(path)
  remote_info = file_info(url)
  if local_info[:mtime] < remote_info[:mtime] || local_info[:size] != remote_info[:size]
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
