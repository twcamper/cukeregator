require 'spec_helper'
module Cukeregator
  describe 'Reading Files' do
    it 'prints the contents of a file from the command line' do
      expect do
        run("bin/cukeregator fixtures/passed.html").should =~ /^\s*<!DOCTYPE html.*html>\s*$/m
      end.to_not raise_error
    end
    it 'reads more than one file' do
       one   = run("bin/cukeregator fixtures/passed.html")
       two   = run("bin/cukeregator fixtures/all_three.html")
       three = run("bin/cukeregator fixtures/passed.html fixtures/all_three.html")
       one.size.should < two.size
       bottom = three.size - 1
       top    = three.size + 2
       (bottom..top).should include(one.size + two.size)
    end
  end
end
