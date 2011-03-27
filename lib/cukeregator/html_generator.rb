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
      h
    end

    def body
      b = new_node(:body)
      b << summary
      b << cucumbers
      b
    end

    def summary
      s = new_node(:div, "summary")
      s.content = @aggregator.scenario_totals[:passed]
      s
    end

    def cucumbers
      c = new_node(:table, "cucumbers")
      @aggregator.docs.each do |doc_data|
        c << row(doc_data)
      end
      c
    end

    def row(doc_data)
      tr = new_node(:tr)
      td = new_node(:td, 'cucumber-result')
      td << link_for(doc_data.path)
      tr << td

      td = new_node(:td)
      p  = new_node(:p, 'totals')
      p.inner_html = doc_data.totals_inner_html
      td << p
      p  = new_node(:p, 'duration')
      p.inner_html = doc_data.duration_inner_html
      td << p

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
      n['class'] = class_name if class_name
      n
    end
  end
end
