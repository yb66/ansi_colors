# Adds several useful methods to strings
module AnsiColors

  # Show where errors originate.
  class Error < StandardError; end


  DEFAULT_COLOR_NAMES = [
    :black,
    :red,
    :green,
    :yellow,
    :blue ,
    :magenta,
    :cyan ,
    :white,
  ]


  module ThreeFourBit

    # Mimic Term AnsiColor methods too.
    BACKGROUNDS = Hash[ DEFAULT_COLOR_NAMES.zip([
      [40, :default_background],
      [41, :default_background],
      [42, :default_background],
      [43, :default_background],
      [44, :default_background],
      [45, :default_background],
      [46, :default_background],
      [47, :default_background]
    ])
    ].each_with_object({}) {|(k,v),hs|
      hs["bkc_#{k}".to_sym] = v
      hs["on_#{k}".to_sym] = v
    }


    DEFAULT_COLORS = Hash[ DEFAULT_COLOR_NAMES.zip(30..37) ]

    DEFAULT_COLOR_CODES = Hash[ (30..37).zip(DEFAULT_COLOR_NAMES) ]


    # The color commands understood by the overridden method_missing method.
    ANSI_CMDS = {
      :bright               =>    [1, :normal],
      :bold                 =>    [1, :normal],
      :faint                =>    [2, :normal],
      :italic               =>    [3, 23],
      :underline            =>    [4, 24],
      :blink_slow           =>    [5, 25],
      :blink_rapid          =>    [6, 26],
      :inverse              =>    [7, 27],
      :conceal              =>    [8, 28],
      :crossed_out          =>    [9, 29],
      :reset                =>    0,
      :normal               =>    22,
      :default_color        =>    39,
      :default_background   =>    49
    }.merge( BACKGROUNDS )
      .merge( DEFAULT_COLORS.each_with_object({}) {|(k,v), hs|
        hs[k] = [v,:default_color]
      })


    # Adds escape chars to the string so that it appears
    # colored when printed on an ansi compliant terminal
    # (non-ansi terminals will display the string surrounded
    # by garbage-like stuff). col_code specifies the color to be used.
    def colorize(color_code, end_code=nil)
      if color_code.respond_to? :gcd
        color_code = DEFAULT_COLOR_CODES[color_code]
        color_code, end_code = get_codes color_code
      else
        color_code, end_code = get_codes color_code
      end
      end_code = ANSI_CMDS[:reset] if end_code.nil?

      "\033[#{color_code}m#{self}\033[#{end_code}m"
    end


    # @private
    def get_codes meth
      fail AnsiColors::Error, "Can't supply nil as a code or a way to get a code" if meth.nil?
      unless color_code = ANSI_CMDS[meth.to_sym]
        fail AnsiColors::Error, "There is no color/method specified with that name or code"
      end

      end_code = :reset

      if color_code.respond_to? :each_index
        color_code, end_code = color_code
      end

      if end_code.is_a? Symbol
        end_code = ANSI_CMDS[end_code]
      end

      [color_code,end_code]
    end


    # Make convenience methods.
    ANSI_CMDS.each do |k,v|
      define_method "ansi_#{k}" do
        colorize k
      end
    end
  end
end
