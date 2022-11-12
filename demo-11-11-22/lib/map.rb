=begin
  

=end


class Map
  def initialize(window)

    @x = @y = @z = 0

    @tile_size = 16
    @tileset = Image.load_tiles('gfx/tileset/sol.png', @tile_size, @tile_size, retro: true)

    @map = generate_map(50,50)
    
  end
  
  def generate_map(size_x=50,size_y=50)
		#Géneration de la map
		map = Hash.new
		size_x.times do |x|
			size_y.times do |y|
				map[[x,y]] = 1,0,nil,nil
			end
		end
		
		nbr_trou_max = (size_x*size_y)/2	# nombre de case créer dans la map
		nbr_trou = 0
		#données des walkers
		new_walker = 50 		# % de chance d'un  walker en plus
		dead_walker = 80 		# % de chance d'un  walker en moins
		change_dir = 20 		# % de chance d'un changement de direction
		
		nbr_walker_max = 20	# nombre max de walker
		nbr_walker = 1
		walker = Hash.new		# génération du tableau de walker
		(nbr_walker_max-1).times do |i|
			walker[i] = nil
		end
		puts walker.size
		walker[0] = rand(1..size_x-1),rand(1..size_y-1),rand(0..3) # génération du premier walker
    

		loop do
			break if nbr_trou >= nbr_trou_max
			walker.each do |id, data| 
				if !data.nil?
					x,y = data[0],data[1]
					if map[[x,y]][0] != 0
						map[[x,y]] = 0,1,nil,nil
						nbr_trou += 1
					end
					case walker[id][3]
						when 0
							walker[id][0] += 1 if walker[id][0] <= size_x-2
						when 1
							walker[id][0] -= 1 if walker[id][0] >= 2
						when 2
							walker[id][1] += 1 if walker[id][1] <= size_y-2
						when 3
							walker[id][1] -= 1  if walker[id][1] >= 2
						end
					walker[id][3] = rand(0..3) if rand(0..100) <= change_dir
					if rand(0..100) <= new_walker and nbr_walker < nbr_walker_max
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
					if rand(0..100) <=  dead_walker and nbr_walker > 1
						walker[id] = nil
						nbr_walker -= 1
					end
				end
			end
		end
		return map
	end

  def button_down(id)
	@map = generate_map(50,50).map if id ==  KB_SPACE
	puts "NEW MAP!!!"
  end

  def button_up(id)
    
  end


  def update
  end

  def draw

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


