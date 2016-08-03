package com.ironbeard.bezoar.battle;

import java.util.ArrayList;

import com.fasterxml.jackson.databind.JsonNode;

public class Battle {
	public ArrayList<Mob> team0;
	public ArrayList<Mob> team1;
	
	public int commandsLeft;
	public ArrayList<String> cmds;
	
	public Battle() {
		team0 = new ArrayList<Mob>();
		team1 = new ArrayList<Mob>();
		cmds  = new ArrayList<String>();
	}
	
	public void loadJson(JsonNode st) {
		team0.clear();
		for (JsonNode mm : st.path("team0")) {
			team0.add(new Mob(mm));
		}
		
		team1.clear();
		for (JsonNode mm : st.path("team1")) {
			team1.add(new Mob(mm));
		}
	}
}
