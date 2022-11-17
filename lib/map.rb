=begin
  

=end


class Map
  def initialize(window)

	@x = @y = @z = 0

	@tile_size = 16
	@tileset = Image.load_tiles('gfx/tileset/sol.png', @tile_size, @tile_size, retro: true)

	@map = generate_walker_map(25,25)
	
	@t_stack = -1
	
	@seed = 1
    
  end
  
  def generate_walker_map(seed = 1 , size_x=50,size_y=50)
		#Géneration de la map
		map = Hash.new
		size_x.times do |x|
			size_y.times do |y|
				map[[x,y]] = 1,0,nil,nil
			end
		end
		
		r  = Random.new(seed)
		
		
		nbr_trou_max = (size_x*size_y)/2	# nombre de case créer dans la map
		nbr_trou = 0
		#données des walkers
		new_walker = 30 		# % de chance d'un  walker en plus
		dead_walker = 20 		# % de chance d'un  walker en moins
		change_dir = 20 		# % de chance d'un changement de direction
		
		nbr_walker_max = 20	# nombre max de walker
		nbr_walker = 1
		walker = Hash.new		# génération du tableau de walker
		@stack = Hash.new
		(nbr_walker_max-1).times do |i|
			walker[i] = nil
			@stack[i] = [nil]
		end
		walker[0] = r.rand(1..size_x-2),r.rand(1..size_y-2),r.rand(0..3) # génération du premier walker*
		@stack[0][0] = walker[0][0],walker[0][1]

		loop do
			break if nbr_trou >= nbr_trou_max
			walker.each do |id, data| 
				if !data.nil?
					x,y = data[0],data[1]
					@stack[id][@stack[id].size] = x,y
					if map[[x,y]][0] != 0
						map[[x,y]] = 0,1,nil,nil
						nbr_trou += 1
					end
					case walker[id][3]
						when 0
							walker[id][0] += 1 if walker[id][0] <= size_x-3
						when 1
							walker[id][0] -= 1 if walker[id][0] >= 2
						when 2
							walker[id][1] += 1 if walker[id][1] <= size_y-3
						when 3
							walker[id][1] -= 1  if walker[id][1] >= 2
						end
					walker[id][3] = r.rand(0..3) if r.rand(0..100) <= change_dir
					if r.rand(0..100) <= new_walker and nbr_walker < nbr_walker_max
						(walker.size-1).times do |i|
							if walker[i] == nil
								walker[i] = walker[id][0],walker[id][1],rand(0..3)
								nbr_walker += 1
								break
							else
								next 
							end
						end
					end
					if r.rand(0..100) <=  dead_walker and nbr_walker > 1
						walker[id] = nil
						nbr_walker -= 1
					end
				else 
					@stack[id][@stack[id].size] = nil
				end
			end
		end
		return map
	end

  def button_down(id)
	  @seed += 1  if id ==  KB_UP
	  @seed -= 1  if id ==  KB_DOWN
	if id ==  KB_SPACE
		@map = generate_walker_map(@seed ,100,100) 
		@t_stack = -1
	end
	
	puts "NEW MAP!!!"
  end

  def button_up(id)
    
  end


  def update
	  @t_stack += 1 if @t_stack[0] <= @stack.size-1
  end

  def draw
	for i in 0..@stack.size-1
		@map[[@stack[i][@t_stack][0],@stack[i][@t_stack][1]]][1] = 4 if @t_stack[i] <= @stack.size-1 and @stack[i][@t_stack] != nil
		@tileset[2].draw(@x+ @stack[i][@t_stack][0] * @tile_size, @y + @stack[i][@t_stack][1] * @tile_size, 1) if @t_stack[i] <= @stack.size-1 and @stack[i][@t_stack] != nil
	end
    @map.each do |coords, texture|
		x, y, = coords[0], coords[1]
		tile1,tile2 = texture[1],texture[2]
		if tile1 != nil
			@tileset[tile1].draw(@x+ x * @tile_size, @y + y * @tile_size, 0)
		end
		if tile2 != nil
			@tileset[tile2].draw(@x+x* @tile_size, @y+y * @tile_size, 10)
		end
	end


  end
end


