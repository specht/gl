#!/usr/bin/env ruby

if ARGV.first == 'rubocop'
    config_path = File.join(File.dirname(File.expand_path(File.realpath($0))), 'rubocop.config.yaml')
    source_path = File.join(File.dirname(File.expand_path(File.realpath($0))), '..', 'gl')
    system("rubocop --lint -c \"#{config_path}\" \"#{source_path}\"")
end