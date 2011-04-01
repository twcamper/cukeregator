# Copyright 2011 ThoughtWorks, Inc. Licensed under the MIT License
module Cukeregator
  class HtmlGenerator
    def initialize(aggregator)
      @aggregator = aggregator
      @doc = new_doc
    end

    def doc
      @doc.root << head
      @doc.root << body
      @doc.to_html
    end

    private

    def head
      h = new_node(:head)
      title = new_node(:title)
      title.content = "All Cucumber Results"
      h << title
      h << inline_css
      h
    end

    def body
      b = new_node(:body)
      b << summary(@aggregator, :id => :summary, :class => @aggregator.status)
      b << new_node(:hr)
      b << cucumbers
      b
    end

    def cucumbers
      c = new_node(:div, :id => :cucumbers )
      @aggregator.docs.each do |doc_data|
        c << summary(doc_data, :class => "#{doc_data.status} cucumber result_summary") << link_for(doc_data.path, :class => :result_detail)
      end
      c
    end

    def link_for(path, attributes = {})
      a  = new_node(:a, attributes)
      a['href'] = path
      a.content = path.split(File::SEPARATOR).last
      a
    end

    def summary(data, attributes)
      s = new_node(:div, attributes)
      s << summary_p(data, 'totals')
      s << summary_p(data, 'duration')
      s
    end

    def summary_p(data, which)
      p  = new_node(:p, which)
      p.inner_html = data.send("#{which}_inner_html")
      p
    end

    def inline_css
      style = new_node(:style)
      style['type'] = 'text/css'
      style.content = "\n#{File.read(File.expand_path(File.dirname(__FILE__)) + '/style.css')}"
      style
    end

    def new_doc
      doc =Nokogiri::XML::Document.new
      root = Nokogiri::XML::Node.new('html', doc)
      root.create_internal_subset( 'html', "-//W3C//DTD XHTML 1.0 Strict//EN", "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd")
      doc << root
      doc
    end

    def new_node(name, attributes = {})
      n = Nokogiri::XML::Node.new(name.to_s, @doc)
      attributes.each do | attr, value |
        n[attr.to_s] = value.to_s
      end
      n
    end
  end
end
