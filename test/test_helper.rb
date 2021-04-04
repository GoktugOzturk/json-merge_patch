# frozen_string_literal: true

require 'coveralls'
require 'simplecov'
require 'simplecov-lcov'

SimpleCov.start do
  add_filter do |source_file|
    source_file.filename =~ /test/
  end
  
  if ENV['CI'] == 'true'
    SimpleCov::Formatter::LcovFormatter.config do |config|
      config.report_with_single_file = true
      config.single_report_path = 'coverage/lcov.info'
    end

    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
      SimpleCov::Formatter::LcovFormatter,
      Coveralls::SimpleCov::Formatter
    ])
  else
    SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
  end
end

Coveralls.wear!

require 'minitest/autorun'

def pending
  yield
  raise 'OMG pending test passed.'
rescue MiniTest::Assertion
  skip 'Still pending'
end

class String
  def strip_heredoc
    indent = scan(/^[ \t]*(?=\S)/).min.send(:size) || 0
    gsub(/^[ \t]{#{indent}}/, '')
  end
end
