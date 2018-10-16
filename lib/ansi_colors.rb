# Adds several useful methods to strings
module AnsiColors

  # Show where errors originate.
  class Error < StandardError; end


  # Mimic Term AnsiColor methods too.
  BACKGROUNDS = {
    :black            =>    [40, :default_background],
    :red              =>    [41, :default_background],
    :green            =>    [42, :default_background],
    :yellow           =>    [43, :default_background],
    :blue             =>    [44, :default_background],
    :magenta          =>    [45, :default_background],
    :cyan             =>    [46, :default_background],
    :white            =>    [47, :default_background],
  }.each_with_object({}) {|(k,v),hs|
    hs["bkc_#{k}".to_sym] = v
    hs["on_#{k}".to_sym] = v
  }


  DEFAULT_COLORS = {
    :black                =>    30,
    :red                  =>    31,
    :green                =>    32,
    :yellow               =>    33,
    :blue                 =>    34,
    :magenta              =>    35,
    :cyan                 =>    36,
    :white                =>    37,
  }


  DEFAULT_COLOR_CODES = {
    30  =>  :black,
    31  =>  :red,
    32  =>  :green,
    33  =>  :yellow,
    34  =>  :blue,
    35  =>  :magenta,
    36  =>  :cyan,
    37  =>  :white
  }


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
    if color_code.respond_to? :integer?
      color_code = DEFAULT_COLOR_CODES[color_code]
    end
    if end_code.nil? or color_code.nil?
      color_code, end_code = get_codes color_code
    end
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


  # Returns a quoted version of the string)
  def quote
    %Q{"#{self}"}
  end


  # Unquote a quoted string (e.g. "'test'".quote => 'test'
  def unquote
    match = /"(.*)"/.match(self)
    match ?  match[1] : self
  end


  # returns true if the stripped version of the string has zero lenght (i.e., 
  # if the string is empty or contains only space characters)
  def blank?
    self.strip.size == 0
  end
end
