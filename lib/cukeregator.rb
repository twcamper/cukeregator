require 'rubygems'
require 'nokogiri'
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
require 'cukeregator/doc_data'
require 'cukeregator/aggregator'

module Cukeregator

  def print(files)
    files.each do |f|
      puts File.read f
    end
  end

  def docs(files)
    Aggregator.new(files).docs
  end


  extend(Cukeregator)
end
