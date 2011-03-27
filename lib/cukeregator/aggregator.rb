module Cukeregator
  
  class Aggregator
    attr_reader :docs

    def initialize(files)
      @docs = files.map do |f|
        DocData.new(File.read(f), f)
      end
    end

    def scenario_totals
      @scenario_totals ||= sum(:scenario_totals)
    end

    def step_totals
      @step_totals ||= sum(:step_totals)
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
