/atom/proc/relativewall_neighbours()
	for(var/turf/simulated/W in range(src,1))
		if(W.can_smooth)
			W.relativewall()
	return

/atom/proc/relativewall()
	var/junction = 0
	if(!istype(src,/turf/simulated/shuttle/wall))
		for(var/turf/simulated/W in orange(src,1))
			if(!W.can_smooth)
				continue
			if(abs(src.x-W.x)-abs(src.y-W.y))
				junction |= get_dir(src,W)


//We use this so we can smooth floor
/turf/simulated
	var/can_smooth = FALSE

/turf/simulated/wall/Del()

	var/temploc = src.loc

	spawn(10)
		for(var/turf/simulated/wall/W in range(temploc,1))
			W.relativewall()

		//for(var/obj/structure/falsewall/W in range(temploc,1)) will do it later
		//	W.relativewall()
	..()

/turf/simulated/wall/relativewall()
	var/junction = 0

	for(var/turf/simulated/wall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y))
			if(src.mineral == W.mineral)
				junction |= get_dir(src,W)
	//var/turf/simulated/wall/wall = src
	icon_state = "[walltype][junction]"
	update_connections(1)
	update_icon()

	if(icon_base)
		cut_overlays()
		var/image/I
		for(var/i = 1 to 4)
			I = image('icons/turf/wall_masks.dmi', "[icon_base][wall_connections[i]]", dir = GLOB.cardinal[i])
			add_overlay(I)

	else return

/turf/simulated/wall/proc/update_connections(propagate = 0)
	var/list/dirs = list()
	for(var/turf/simulated/wall/W in RANGE_TURFS(1, src) - src)
		if(propagate)
			W.update_connections()
			W.update_icon()
		if(can_join_with(W))
			dirs += get_dir(src, W)

	wall_connections = dirs_to_corner_states(dirs)

/turf/simulated/wall/proc/can_join_with(var/turf/simulated/wall/W)
	if(src.icon_base == W.icon_base)
		return 1
	return 0

