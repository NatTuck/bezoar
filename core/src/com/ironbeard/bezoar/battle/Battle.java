package com.ironbeard.bezoar.battle;

import java.util.ArrayList;
import java.util.HashMap;

import com.fasterxml.jackson.databind.JsonNode;

public class Battle {
	public HashMap<Posn, Champ> champs;
	public ArrayList<Event> events;
	
	public int commandsLeft;
	public ArrayList<String> cmds;
	
	public Battle() {
		champs = new HashMap<Posn, Champ>();
		events = new ArrayList<Event>();
		cmds   = new ArrayList<String>();
	}
	
	public void loadJson(JsonNode st) {
		champs.clear();
		for (JsonNode cc : st.path("champs")) {
			Champ champ = new Champ(cc);
			champs.put(champ.posn, champ);
		}
		
		events.clear();
		for (JsonNode ee : st.path("events")) {
			events.add(new Event(ee));
		}
	}
}
