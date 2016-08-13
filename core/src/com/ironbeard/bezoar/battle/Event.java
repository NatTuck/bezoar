package com.ironbeard.bezoar.battle;

import java.util.ArrayList;

import com.fasterxml.jackson.databind.JsonNode;

public class Event {
	public final int target_id;
	public final int source_id;
	public final String effect;
	public final ArrayList<Integer> args;
	
	public Event(JsonNode node) {
		target_id = node.get(0).asInt();
		source_id = node.get(1).asInt();
		
		JsonNode eff = node.get(2).path("effect");
		effect = eff.get(0).toString();
		
		args = new ArrayList<Integer>();
		for (int ii = 1; ii < eff.size(); ++ii) {
			args.add(eff.get(ii).asInt());
		}
	}
}
