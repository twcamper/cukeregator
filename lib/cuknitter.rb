require 'rubygems'
module Cuknitter

  def print(files)
    files.each do |f|
      puts File.read f
    end
  end
  extend(Cuknitter)
end
