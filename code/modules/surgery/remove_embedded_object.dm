

/datum/surgery/embedded_removal
	name = "removal of embedded objects"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/retract_skin, /datum/surgery_step/remove_object)
	species = list(/mob/living/carbon/human)
	location = "anywhere"
	has_multi_loc = 1


/datum/surgery_step/remove_object
	time = 32
	allowed_organs = list("r_arm","l_arm","r_leg","l_leg","chest","head")
	accept_hand = 1
	var/obj/item/organ/limb/L = null


/datum/surgery_step/remove_object/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	L = new_organ
	if(L)
		user.visible_message("[user] looks for objects embedded in [target]'s [parse_zone(user.zone_sel.selecting)].", "<span class='notice'>You look for objects embedded in [target]'s [parse_zone(user.zone_sel.selecting)]...</span>")
	else
		user.visible_message("[user] looks for [target]'s [parse_zone(user.zone_sel.selecting)].", "<span class='notice'>You look for [target]'s [parse_zone(user.zone_sel.selecting)]...</span>")


/datum/surgery_step/remove_object/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(L)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			var/objects = 0
			for(var/obj/item/I in L.embedded_objects)
				objects++
				I.loc = get_turf(H)
				L.embedded_objects -= I

			if(!H.has_embedded_objects())
				H.clear_alert("embeddedobject")

			if(objects > 0)
				user.visible_message("[user] sucessfully removes [objects] objects from [H]'s [L.getDisplayName()]!", "<span class='notice'>You sucessfully remove [objects] objects from [H]'s [L.getDisplayName()].</span>")
			else
				user << "<span class='warning'>You find no objects embedded in [H]'s [L.getDisplayName()]!</span>"

	else
		user << "<span class='warning'>You can't find [target]'s [parse_zone(user.zone_sel.selecting)], let alone any objects embedded in it!</span>"

	return 1