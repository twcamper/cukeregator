module Cukeregator
  module SummaryFormatter
    def count(which)
      total = yield("total_#{which}s".to_sym)
      "#{total} #{which}#{'s' if total> 1}"
    end
    def totals_inner_html(&block)
      totals = count(:scenario, &block) 
      totals += status_counts(:scenario, &block)
      totals += "<br />"
      totals += count(:step, &block)
      totals += status_counts(:step, &block)
    end
    def status_counts(which)
      totals = yield("#{which}_totals".to_sym)
      counts = [:failed, :skipped, :undefined, :pending, :passed].map do |status|
        "#{totals[status]} #{status}" if totals[status] > 0
      end.compact
      " (#{counts.join(', ')})"
    end
    def duration_inner_html(s)
      "Combined Duration <strong>#{s}</strong>"
    end
    extend(SummaryFormatter)
  end
  class Aggregator
    include Status

    attr_reader :docs

    def initialize(files)
      @docs = files.map do |f|
        HtmlReader.new(File.read(f), f)
      end
    end

    def scenario_totals
      @scenario_totals ||= sum_hash(:scenario_totals)
    end

    def total_scenarios
      @total_scenarios ||= sum(:total_scenarios)
    end

    def totals_inner_html
      SummaryFormatter.totals_inner_html {|method| self.send(method) }
    end
    
    def duration_inner_html
      SummaryFormatter.duration_inner_html(duration_string)
    end
    def total_steps
      @total_steps ||= sum(:total_steps)
    end

    def step_totals
      @step_totals ||= sum_hash(:step_totals)
    end

    def duration
      @duration ||= @docs.inject(0) do |result, doc|
        result += doc.duration
        result
      end
    end

    def duration_string
      hours = (duration / 3600).to_i
      min_sec = duration % 3600
      minutes = (min_sec / 60).to_i
      seconds = min_sec % 60

      s = ""
      s += "#{hours}h" if hours > 0
      s += "#{minutes}m"
      s += "#{seconds.to_s[0..5]}s"
      s
    end

    private

    def sum(which)
      docs.inject(0) do |result, doc|
        result += doc.send(which)
        result
      end
    end

    def sum_hash(which)
      h = Hash.new(0) 
      docs.each do |d|
        d.send(which).each do |key, value|
          h[key] += value
        end
      end
      h
    end

  end
end
