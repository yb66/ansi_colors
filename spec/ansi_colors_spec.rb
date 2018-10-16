require "spec_helper"
require_relative "../lib/ansi_colors.rb"

context "Mixing" do
  Mixed = Class.new(String) do
    include AnsiColors
  end

  When(:mixed_instance) {
    Mixed.new "Hello"
  }

  Then { mixed_instance.respond_to? :quote }
  Then { mixed_instance.respond_to? :unquote }
  Then { mixed_instance.respond_to? :colorize }
  AnsiColors::ANSI_CMDS.each do |k,v|
    And { mixed_instance.respond_to? "ansi_#{k}".to_sym }
  end
end