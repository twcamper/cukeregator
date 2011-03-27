module Cukeregator
  module Status
    def status
      return :failed if scenario_totals[:failed] > 0
      return :passed if scenario_totals[:passed] > 0
      return :pending if scenario_totals[:pending] > 0
    end
  end
end
