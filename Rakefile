require 'rubygems'
require 'rake/testtask'
require 'rspec/core/rake_task'
require 'rake/rdoctask'
require 'rake/gempackagetask'

task :default do
  Rake.application.tasks_in_scope(["cukeregator:test"]).each do |t|
    t.invoke
  end
end

namespace :cukeregator do

  task :readme do
    require 'redcloth'
    puts RedCloth.new(File.read("README.textile")).to_html
  end

  namespace :test do
    desc "unit specs"
    RSpec::Core::RakeTask.new(:unit) do |t|
      t.pattern = "spec/cukeregator/*_spec.rb"
      t.rspec_opts = ["--color" , "--format" , "doc" ]
    end
  end

  RDOC_OPTS = ["--all" , "--quiet" , "--line-numbers" , "--inline-source", 
    "--main", "README.textile", 
    "--title", "Cukeregator: many into one"]
  XTRA_RDOC = %w{README.textile LICENSE }

  Rake::RDocTask.new do |rd|
    rd.rdoc_dir = "doc/rdoc"
    rd.rdoc_files.include("**/*.rb")
    rd.rdoc_files.add(XTRA_RDOC)
    rd.options = RDOC_OPTS
  end

  spec = Gem::Specification.new do |s|
    s.name = 'cukeregator'
    s.version = '0.1.3'
    s.rubyforge_project = s.name

    s.platform = Gem::Platform::RUBY
    s.has_rdoc = true
    s.extra_rdoc_files = XTRA_RDOC
    s.rdoc_options += RDOC_OPTS
    s.summary = "aggregates many cucumber results files into one summary page"
    s.description = s.summary
    s.author = "Tim Camper"
    s.email = 'twcamper@thoughtworks.com'
    s.homepage = 'http://github.com/twcamper/cukeregator'
    s.required_ruby_version = '>= 1.8.7'
    s.add_dependency('nokogiri', '>= 1.4.0')
    s.default_executable = "cukeregator"
    s.executables = [s.default_executable]

    s.files =  %w(LICENSE README.textile Rakefile) + 
      FileList["lib/**/*.{rb,css}", "bin/*"].to_a

    s.require_path = "lib"
  end

  Rake::GemPackageTask.new(spec) do |p|
    p.need_zip = true
    p.need_tar = true
    p.gem_spec = spec
  end
end
