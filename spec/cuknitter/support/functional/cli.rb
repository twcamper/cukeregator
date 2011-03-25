
require 'popen4'

module Spec
  module Functional
    module Cli
      def run(command)
        out = nil
        error = nil
        status = POpen4::popen4(command) do |stdout, stderr|
          out = stdout.read.strip
          error = stderr.read.strip
        end
        raise error if status.exitstatus != 0
        return out
      end
    end
  end
end
