#!/usr/bin/env ruby
require 'net/http'
require 'json'
require 'pp'

def cluster_health
  url = 'http://localhost:9200/_cluster/health'
  uri = URI(url)
  response = Net::HTTP.get(uri)
  JSON.parse(response)
end

def wait_cluster_health_green
  puts 'Check cluster health is green'
  delay_seconds = 2
  max_time = 60
  count = max_time / delay_seconds
  (0...count).each do |i|
    health = cluster_health()
    if health['status'] == 'green'
      return true
    end
    puts "Waiting.. cluster status is still #{health['status']}"
    sleep delay_seconds
  end
  false
end

def get_running_nodes
  (1..2).select do |i|
    File::exists? "/var/run/elasticsearch/es1-data#{i}.pid"
  end
end

def start_node(num)
  puts "Start nodes: #{num}"
  base_path = File.expand_path(File.dirname(__FILE__))
  `#{base_path}/start_data_node.sh #{num}`
end

def stop_node(num)
  puts "Stop nodes: #{num}"
  base_path = File.expand_path(File.dirname(__FILE__))
  `#{base_path}/stop_data_node.sh #{num}`
end

# restart elasticsearch with zero downtime
def restart
  running_nodes = get_running_nodes()

  puts "Running nodes: #{running_nodes}"

  if running_nodes.empty?
    start_node 1
    exit
  end

  if running_nodes.count > 1
    abort "still restarting. try again after some minutes"
  end

  running_node = running_nodes.first.to_i

  running_nodes[1..-1].each do |i|
    stop_node i
  end

  new_node = running_node == 1 ? 2 : 1
  start_node new_node

  puts "Wait some seconds for starting new node"
  sleep 10

  abort('cluster health is not green') unless wait_cluster_health_green()

  stop_node running_node

  puts "Elasticsearch restarted successfully."
end

if __FILE__ == $0
  restart()
end
