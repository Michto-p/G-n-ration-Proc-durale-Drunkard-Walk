require "rubygems"
require 'gosu'

include Gosu

require_relative 'lib/map.rb'

class Game < Window
  def initialize(params = {})
    # default values
    params[:width]       ||= 640*2
    params[:height]      ||= 480*2
    params[:fullscreen]  ||= false
    params[:caption]     ||= 'Procedual map'
    params[:show_cursor] ||= true
    params[:escape_key]  ||= KB_ESCAPE
    params[:resizable]   ||= true

    # we store the show_cursor state and escape key(s) for callback methods below
    @show_cursor = params[:show_cursor]
    @escape_key  = params[:escape_key]
    @resizable	 = params[:resizable]

    # Gosu window setup
    super(params[:width], params[:height], {fullscreen: params[:fullscreen],resizable: params[:resizable]})

    self.caption = params[:caption]
    @font = Gosu::Font.new(24)
    @main_state = Map.new(self)
  end

  def needs_cursor?; true; end

  def button_down(id)
    super
    @main_state.button_down(id)
    close! if id ==  @escape_key
  end

  def button_up(id)
    @main_state.button_up(id)
  end


  def update
    @main_state.update
  end

  def draw
    scale(1,1)do
      @main_state.draw
    end
  end
end

Game.new.show
