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

  context "The codes" do
    context "Valid codes" do
      AnsiColors::ANSI_CMDS.each do |k,v|
        context k.to_s do
          When(:code) { mixed_instance.get_codes k }
          Then { code.first == v or code.first == v.first }
        end
      end

      context "30, black" do
        When(:coloured) { mixed_instance.colorize 30 }
        Then { coloured == "\e[30mHello\e[39m" }
      end
    end

    context "Invalid codes" do
      context "Given a colour not in the list" do
        it "should raise an error" do
          expect { mixed_instance.colorize :orange }.to raise_error AnsiColors::Error
        end
      end
      context "Given a number that is not valid" do
        it "should raise an error" do
          expect { mixed_instance.colorize 33_000_000 }.to raise_error AnsiColors::Error
        end
      end
    end
  end

  
  context "Calling colours directly" do
    context "reset" do
      When(:coloured) { mixed_instance.ansi_reset }
      Then { coloured == "\e[0mHello\e[0m" }
    end
    context "bold" do
      When(:coloured) { mixed_instance.ansi_bold }
      Then { coloured == "\e[1mHello\e[22m" }
    end
    context "underline" do
      When(:coloured) { mixed_instance.ansi_underline }
      Then { coloured == "\e[4mHello\e[24m" }
    end

    context "black" do
      When(:coloured) { mixed_instance.ansi_black }
      Then { coloured == "\e[30mHello\e[39m" }
    end
    context "red" do
      When(:coloured) { mixed_instance.ansi_red }
      Then { coloured == "\e[31mHello\e[39m" }
    end
    context "green" do
      When(:coloured) { mixed_instance.ansi_green }
      Then { coloured == "\e[32mHello\e[39m" }
    end
    context "yellow" do
      When(:coloured) { mixed_instance.ansi_yellow }
      Then { coloured == "\e[33mHello\e[39m" }
    end
    context "blue" do
      When(:coloured) { mixed_instance.ansi_blue }
      Then { coloured == "\e[34mHello\e[39m" }
    end
    context "magenta" do
      When(:coloured) { mixed_instance.ansi_magenta }
      Then { coloured == "\e[35mHello\e[39m" }
    end
    context "cyan" do
      When(:coloured) { mixed_instance.ansi_cyan }
      Then { coloured == "\e[36mHello\e[39m" }
    end
    context "white" do
      When(:coloured) { mixed_instance.ansi_white }
      Then { coloured == "\e[37mHello\e[39m" }
    end

    context "on_black" do
      When(:coloured) { mixed_instance.ansi_on_black }
      Then { coloured == "\e[40mHello\e[49m" }
    end
    context "on_red" do
      When(:coloured) { mixed_instance.ansi_on_red }
      Then { coloured == "\e[41mHello\e[49m" }
    end
    context "on_green" do
      When(:coloured) { mixed_instance.ansi_on_green }
      Then { coloured == "\e[42mHello\e[49m" }
    end
    context "on_yellow" do
      When(:coloured) { mixed_instance.ansi_on_yellow }
      Then { coloured == "\e[43mHello\e[49m" }
    end
    context "on_blue" do
      When(:coloured) { mixed_instance.ansi_on_blue }
      Then { coloured == "\e[44mHello\e[49m" }
    end
    context "on_magenta" do
      When(:coloured) { mixed_instance.ansi_on_magenta }
      Then { coloured == "\e[45mHello\e[49m" }
    end
    context "on_cyan" do
      When(:coloured) { mixed_instance.ansi_on_cyan }
      Then { coloured == "\e[46mHello\e[49m" }
    end
    context "on_white" do
      When(:coloured) { mixed_instance.ansi_on_white }
      Then { coloured == "\e[47mHello\e[49m" }
    end

    context "black" do
      When(:coloured) { mixed_instance.ansi_black }
      Then { coloured == "\e[30mHello\e[39m" }
    end
    context "red" do
      When(:coloured) { mixed_instance.ansi_red }
      Then { coloured == "\e[31mHello\e[39m" }
    end
    context "green" do
      When(:coloured) { mixed_instance.ansi_green }
      Then { coloured == "\e[32mHello\e[39m" }
    end
    context "yellow" do
      When(:coloured) { mixed_instance.ansi_yellow }
      Then { coloured == "\e[33mHello\e[39m" }
    end
    context "blue" do
      When(:coloured) { mixed_instance.ansi_blue }
      Then { coloured == "\e[34mHello\e[39m" }
    end
    context "magenta" do
      When(:coloured) { mixed_instance.ansi_magenta }
      Then { coloured == "\e[35mHello\e[39m" }
    end
    context "cyan" do
      When(:coloured) { mixed_instance.ansi_cyan }
      Then { coloured == "\e[36mHello\e[39m" }
    end
    context "white" do
      When(:coloured) { mixed_instance.ansi_white }
      Then { coloured == "\e[37mHello\e[39m" }
    end

    context "Background only bkc_black" do
      When(:coloured) { mixed_instance.ansi_bkc_black }
      Then { coloured == "\e[40mHello\e[49m" }
    end
    context "Background only bkc_red" do
      When(:coloured) { mixed_instance.ansi_bkc_red }
      Then { coloured == "\e[41mHello\e[49m" }
    end
    context "Background only bkc_green" do
      When(:coloured) { mixed_instance.ansi_bkc_green }
      Then { coloured == "\e[42mHello\e[49m" }
    end
    context "Background only bkc_yellow" do
      When(:coloured) { mixed_instance.ansi_bkc_yellow }
      Then { coloured == "\e[43mHello\e[49m" }
    end
    context "Background only bkc_blue" do
      When(:coloured) { mixed_instance.ansi_bkc_blue }
      Then { coloured == "\e[44mHello\e[49m" }
    end
    context "Background only bkc_magenta" do
      When(:coloured) { mixed_instance.ansi_bkc_magenta }
      Then { coloured == "\e[45mHello\e[49m" }
    end
    context "Background only bkc_cyan" do
      When(:coloured) { mixed_instance.ansi_bkc_cyan }
      Then { coloured == "\e[46mHello\e[49m" }
    end
    context "Background only bkc_white" do
      When(:coloured) { mixed_instance.ansi_bkc_white }
      Then { coloured == "\e[47mHello\e[49m" }
    end
  end

end