require 'rubygems'
require 'nokogiri'
require 'hpricot'

module Cukeregator

  def print(files)
    files.each do |f|
      puts File.read f
    end
  end

  def docs(files)
    DocList.new(files)
  end

  class DocList
    attr_reader :docs
    def initialize(files)
      @docs = files.map do |f|
        Doc.new(File.read(f))
      end
    end
    def knit
      new_doc = Nokogiri::HTML::Document.new
      html    = Nokogiri::XML::Node.new('html', new_doc)
      html    << docs.first.at(:head)
      body    = Nokogiri::XML::Node.new('body', new_doc)
      docs.each do |doc|
        doc.body.children.each do |c|
          body << c
        end
      end
      html << body
      new_doc << html
      new_doc.to_s
    end
  end

  class Doc
    attr_reader :totals, :doc

    def initialize(html)
      @doc = Nokogiri::HTML(html)
      #@doc = Hpricot(html)
      @totals = parse_totals(totals_string)
    end

    def at(expression)
      @doc.at(expression)
    end

    def body
      @doc.at :body
    end
    
    def html
      @doc.at :html
    end
    def totals_string
      js = scripts.grep(/totals/).to_s
      js =~ /innerHTML[=\s]+"([^\"]+)/
      $1
    end

    def parse_totals(totals_string)
      raise "No Totals Found" unless totals_string
      totals_string =~ /\d+ scenarios? \(([^\)]+)/
      s = $1
      result = Hash.new(0)
      s.split(',').each do | pair|
        count, name = pair.strip.split(' ')
        result[name.to_sym] = count.to_i
      end
      result
    end

    def scripts
      @doc.search("body script").map {|script| script.text }
    end

  end
  extend(Cukeregator)
end
