extends Node

var map = []
var map_size =  64
var rooms = []
var room_count
var min_number_of_rooms = 10
var max_number_of_rooms = 20
var min_rooms_size = 5
var max_rooms_size = 15

var empty_tile = 0
var floor_tile = 1
var wall_tile = 2

var bigger_coridor

#########room class#########
class room:
	var x
	var y
	var w
	var h
	func tst(i_type):
		pass
	func random_pos_and_size(map_size,min_room_size,max_room_size):
		x = rand_range_int(1, map_size - max_room_size-1)
		y = rand_range_int(1, map_size - max_room_size-1)
		
		w = rand_range_int(min_room_size, max_room_size)
		h = rand_range_int(min_room_size, max_room_size)
		
		pass #end random_pos
	func rand_range_int(min_i, max_i):
		randomize()
		return min_i + (randi() % int(max_i - min_i + 1))
	func mid():
		return	{
			'x': self.x + (self.w / 2),
			'y': self.y + (self.h / 2)
		}
		pass
	func room_distance(check):
		var mid = self.mid()
		var check_mid = check.mid()
		return min(abs(mid.x - check_mid.x) - (w / 2) - (check.w / 2), abs(mid.y - check_mid.y) - (h / 2) - (check.h / 2));
		pass
	func colide(check):
		#aabb collision check
		if (!((x + w < check.x) || (x > check.x + check.w) || (y + h < check.y) || (y > check.y + check.h))): return true
		return false
		pass #end colide
	func random_point_in_room():
		return {
			'x':rand_range_int(x,x+w-1),
			'y':rand_range_int(y,y+h-1)
		}
	func _to_string():
		return "x-"+str(x)+"y-"+str(y)+"w-"+str(w)+"h-"+str(h)+" | "

########end room class###########



func _init():
	for x in range(map_size):
		map.append([])
		for y in range(map_size):
			map[x].append(empty_tile)
	pass #end init
			
func clear_map():
	for x in range(map_size):
		for y in range(map_size):
			map[x][y] = empty_tile
	pass #end clear_map

func genrate():
	#reset map
	clear_map()
	rooms = []
	
	#random number of rooms
	room_count = rand_range_int(min_number_of_rooms, max_number_of_rooms)
	
	#####create rooms
	for i in room_count:
		var new_room = room.new()
		#random room pos and  room size
		new_room.random_pos_and_size(map_size,min_rooms_size,max_rooms_size)
		
		#if room colides with another room
		while(does_collide(new_room,i)):
			new_room.random_pos_and_size(map_size,min_rooms_size,max_rooms_size)
		#decrease room size by 1
		new_room.w-=1;
		new_room.h-=1;
		#append to room object/list
		rooms.append(new_room)
		pass #end for 

	#create coridors 
	#(loop rooms get closest to current build coridor between them)
	create_coridors()
	
	#fill room floors
	#loop all rooms
	for j in room_count:
		var room = rooms[j]#current room
		#from rooms start xy pos to room width and height
		var x = room.x
		while ( x < room.x + room.w ):
			var y = room.y
			while ( y < room.y + room.h ):
				#fill with floor
				map[x][y] = floor_tile;
				y+=1

			x+=1
		
			
	#surround  rooms with wall tiles
	#loop tilemap
	var x = 0;
	while ( x < map_size):
		var y = 0
		while ( y < map_size):
		   #if found floor tile (edge of room or coridor)
			if (map[x][y] == 1):
				#loop from befor floor tile to after (for both xy)
				var xx = x - 1
				while ( xx <= x + 1):
					var yy = y - 1
					while (yy <= y + 1):
						#if found empty tile put a wall
						if (map[xx][yy] == 0):map[xx][yy] = wall_tile
						yy+=1
					xx+=1
				

			y+=1
		x+=1
	#end fill walls
	#print(map)
	pass # end genrate


func does_collide(room,ignore = null):
	if rooms.empty():return false #no rooms dont check
	for i in rooms.size():
		if i == ignore: continue
		var check = rooms[i]
		if room.colide(check):return true
	return false
	pass #end does_collide

func create_coridors():

	#connect each room to next room
	for i in rooms.size():
		var roomA = rooms[i]
		#if next room bigger then room array size exit loop
		if(i+1 > rooms.size()-1):break
		var roomB =  rooms[i+1]	
		#random point in current room
		var pointA = roomA.random_point_in_room()
		#random point in closest room
		var pointB = roomB.random_point_in_room()
		
		connect_rooms(pointA,pointB)
		pass
	pass #end create_coridors	


func connect_rooms(pointA,pointB):
	#while the points are not equal (were trying to incrament point b to point a)
	while ((pointB.x != pointA.x) || (pointB.y != pointA.y)):
		#if the points x is not equal
		if (pointB.x != pointA.x):
		#if b x is bigger deincrament it else incrament (if its smaller)
			if (pointB.x > pointA.x): pointB.x-=1
			else: pointB.x+=1
		elif  (pointB.y != pointA.y):#same for y
				if (pointB.y > pointA.y): pointB.y-=1
				else: pointB.y+=1
		#add floor to the tilemap where the current point b xy is
		map[pointB.x][pointB.y] = 1;
		if bigger_coridor:
			map[pointB.x+1][pointB.y] = 1;
			map[pointB.x][pointB.y+1] = 1;
		pass

	pass#end connect_rooms

############ utils ##############

func rand_range_int(min_i, max_i):
	return min_i + (randi() % int(max_i - min_i + 1))


func get_random_tile_room1():
	
	var pos = rooms[0].mid()
	return Vector2(pos.x,pos.y)

