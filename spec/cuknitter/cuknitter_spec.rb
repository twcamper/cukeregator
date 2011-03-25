require 'spec_helper'
module Cuknitter
  describe 'Reading Files' do
    it 'prints the contents of a file from the command line' do
      expect do
        run("bin/cuknitter fixtures/passed.html").should =~ /^\s*<!DOCTYPE html.*html>\s*$/m
      end.to_not raise_error
    end
    it 'reads more than one file' do
       one   = run("bin/cuknitter fixtures/passed.html")
       two   = run("bin/cuknitter fixtures/all_three.html")
       three = run("bin/cuknitter fixtures/passed.html fixtures/all_three.html")
       one.size.should < two.size
       bottom = three.size - 1
       top    = three.size + 2
       (bottom..top).should include(one.size + two.size)
    end
  end
end
