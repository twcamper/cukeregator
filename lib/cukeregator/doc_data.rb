module Cukeregator

  class DocData
    attr_reader :totals_inner_html, :scenario_totals, :step_totals
    attr_reader :duration_inner_html, :duration, :path

    def initialize(html, path)
      @scripts             = parse_scripts(Nokogiri::HTML(html))
      @path                = path
      @scenario_totals     = parse_totals(:scenario)
      @step_totals         = parse_totals(:step)
      @duration            = parse_duration
    end

    def totals_inner_html
      @totals_inner_html ||= js_string(:totals)
    end

    def duration_inner_html
      @duration_inner_html ||= js_string(:duration)
    end

    private
    def parse_totals(which)
      totals_inner_html =~ /\d+ #{which}s? \(([^\)]+)/
      s = $1
      raise("no total string found for '#{which}'") unless s
      to_hash(s)
    end
    
    def parse_duration
      time_string = duration_inner_html[/(\d+h)?\d+m\d+\.\d\d\ds/]
      hours_minutes_seconds = time_string.split(/[hms]/)

      duration = 0.0
      if hours_minutes_seconds.size == 3
        duration += hours_minutes_seconds.shift.to_f * 3600.0
      end
      duration += hours_minutes_seconds[0].to_f * 60.0
      duration += hours_minutes_seconds[1].to_f
      duration
    end

    def js_string(which)
      js = @scripts.grep(/#{which}/).to_s
      js =~ /innerHTML[=\s]+"([^\"]+)/
      inner_html = $1
      raise "no innerHTML found for '#{which}' in scripts" unless inner_html
      inner_html
    end

    def to_hash(s)
      result = Hash.new(0)
      s.split(',').each do | pair|
        count, name = pair.strip.split(' ')
        result[name.to_sym] = count.to_i
      end
      result
    end

    # our data lies in javascript functions at the bottom of the body, because
    # Aslak can't put up the totals until the suite completes
    def parse_scripts(doc)
      doc.search("body script").map {|script| script.text }
    end

  end
end
