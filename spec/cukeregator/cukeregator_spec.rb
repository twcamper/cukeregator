require 'spec_helper'
module Cukeregator
  describe 'Reading Files' do
    it 'prints the contents of a file from the command line' do
      expect do
        run("bin/cukeregator fixtures/passed.html").should =~ /^\s*<!DOCTYPE html.*html>\s*$/m
      end.to_not raise_error
    end
   
    it 'reads more than one file' do
      Cukeregator.docs(%w[fixtures/passed.html fixtures/all_three.html]).size.should == 2
    end
  end

  describe HtmlReader do
    before(:all) do
      @doc_data = Aggregator.new(%w[fixtures/passed_and_failed.html]).docs.first
    end

    context 'totals' do
      it 'should provide scenario totals as a string' do
        @doc_data.totals_inner_html.should == "159 scenarios (13 failed, 146 passed)<br />833 steps (13 failed, 30 skipped, 790 passed)"
      end
      it 'should provide scenario totals as a hash' do
        @doc_data.scenario_totals.should == {:failed=>13, :passed=>146}
      end
      it 'should provide default of 0 for missing result type' do
        @doc_data.scenario_totals[:pending].should == 0
      end
      it 'should provide total scenarios as a number' do
        @doc_data.total_scenarios.should == 159
      end
      it 'should provide total steps as a number' do
        @doc_data.total_steps.should == 833
      end
    end
    context 'duration' do
      it 'should provide duration as a string' do
        @doc_data.duration_inner_html.should == "Finished in <strong>1h9m33.435s seconds</strong>"
      end
      it 'should provide duration as a number of seconds' do
        @doc_data.duration.should == 4173.435
      end
    end
    context 'status' do
      it 'should return failed' do
        @doc_data.status.should == :failed
      end
      it 'should return passed' do
        @doc_data = Aggregator.new(%w[fixtures/passed.html]).docs.first
        @doc_data.status.should == :passed
      end
      it 'should return pending' do
        @doc_data = Aggregator.new(%w[fixtures/pending.html]).docs.first
        @doc_data.status.should == :pending
      end
    end
  end

  describe Aggregator do
    context 'non-zero scenario totals' do
      before(:all) do
        @aggregator = Aggregator.new %w[fixtures/all_three.html fixtures/passed_and_failed.html]
      end
      it 'should sum passed' do
        @aggregator.scenario_totals[:passed].should == 18 + 146 
      end
      it 'should sum failed' do
        @aggregator.scenario_totals[:failed].should == 13 + 2 
      end
      it 'should sum pending' do
        @aggregator.scenario_totals[:pending].should == 1 + 0 
      end
      it 'should provide total scenarios as a number' do
        @aggregator.total_scenarios.should == 180
      end
    end
    context 'missing scenario totals' do
      it 'should return zero for missing result types' do
        @aggregator = Aggregator.new %w[fixtures/pending.html fixtures/passed.html]
        @aggregator.scenario_totals[:failed].should == 0
        @aggregator.scenario_totals[:skipped].should == 0
      end
    end
    context 'step totals' do
      before(:all) do
        @aggregator = Aggregator.new %w[fixtures/pending.html fixtures/passed.html fixtures/passed_and_failed.html]
      end
      it 'should sum passed' do
        @aggregator.step_totals[:passed].should == 0 + 2 + 790
      end
      it 'should sum failed' do
        @aggregator.step_totals[:failed].should == 0 + 0 + 13
      end
      it 'should sum pending' do
        @aggregator.step_totals[:pending].should == 1 + 0 + 0 
      end
      it 'should sum skipped' do
        @aggregator.step_totals[:skipped].should == 2 + 0 + 30
      end
      it 'should provide total steps as a number' do
        @aggregator.total_steps.should == 838
      end
    end
    context 'duration totals' do
      before(:all) do
        @aggregator = Aggregator.new %w[fixtures/all_three.html fixtures/pending.html fixtures/passed.html fixtures/passed_and_failed.html]
      end
      it 'should provide total duration in seconds' do
        @aggregator.duration.should == 4177.621
      end
      it 'should provide total duration as a formatted string in hours, minutes, seconds' do
        @aggregator.duration_string.should == '1h9m37.621s'
      end
      it 'should not show hours when they are zero' do
        @agg = Aggregator.new %w[fixtures/pending.html fixtures/passed.html fixtures/all_three.html]
        @agg.duration_string.should == "0m4.186s"
      end
    end
    context 'status' do
      it 'should return passed for passed + pending' do
        @aggregator = Aggregator.new %w[fixtures/pending.html fixtures/passed.html]
        @aggregator.status.should == :passed
      end
      it 'should return failed for passed + failed' do
        @aggregator = Aggregator.new %w[fixtures/pending.html fixtures/passed_and_failed.html]
        @aggregator.status.should == :failed
      end
      it 'should return failed for just failed' do
        @aggregator = Aggregator.new %w[fixtures/passed_and_failed.html]
        @aggregator.status.should == :failed
      end
      it 'should return failed for all' do
        @aggregator = Aggregator.new %w[fixtures/all_three.html fixtures/pending.html fixtures/passed.html fixtures/passed_and_failed.html]
        @aggregator.status.should == :failed
      end
    end
  end
end
