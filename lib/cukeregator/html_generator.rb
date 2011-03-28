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

    def new_doc
      doc =Nokogiri::XML::Document.new
      root = Nokogiri::XML::Node.new('html', doc)
      root.create_internal_subset( 'html', "-//W3C//DTD XHTML 1.0 Strict//EN", "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd")
      doc << root
      doc
    end

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
      b << summary
      b << cucumbers
      b
    end

    def summary
      s = new_node(:div, @aggregator.status)
      s['id'] = "summary"
      s << summary_p(@aggregator, 'totals')
      s << summary_p(@aggregator, 'duration')
      s
    end

    def cucumbers
      c = new_node(:table)
      c['id'] = "cucumbers"
      tb = new_node(:tbody)
      @aggregator.docs.each do |doc_data|
        tb << row(doc_data)
      end
      c << tb
      c
    end

    def row(doc_data)
      tr = new_node(:tr, doc_data.status)
      td = new_node(:td, 'result-detail')
      td << link_for(doc_data.path)
      tr << td

      td = new_node(:td, 'result-summary')
      td << summary_p(doc_data, 'totals')
      td << summary_p(doc_data, 'duration')
      tr << td
      tr
    end

    def link_for(path)
      a  = new_node(:a)
      a['href'] = path
      a.content = path
      a
    end

    def new_node(name, class_name = nil)
      n = Nokogiri::XML::Node.new(name.to_s, @doc)
      n['class'] = class_name.to_s if class_name
      n
    end

    def summary_p(o, which)
      p  = new_node(:p, which)
      p.inner_html = o.send("#{which}_inner_html")
      p
    end

    def inline_css
      style = new_node(:style)
      style['type'] = 'text/css'
      style.content = "\n#{File.read(File.expand_path(File.dirname(__FILE__)) + '/style.css')}"
      style
    end
  end
end
