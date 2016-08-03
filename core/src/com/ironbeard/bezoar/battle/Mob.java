package com.ironbeard.bezoar.battle;

import java.util.ArrayList;
import com.fasterxml.jackson.databind.JsonNode;

public class Mob {
	public String name;
	public int hp;
	public int maxHp;
	public String status;
	public String cmd;

	public ArrayList<Skill> skills;

	private void init() {
		name = "";
		hp = 0;
		maxHp = 0;
		status = "";
		cmd = "";
		
		skills = new ArrayList<Skill>();
	}
	
	public Mob() {
		init();
	}
	
	public Mob(JsonNode node) {
		init();
		loadJson(node);
	}

	public void loadJson(JsonNode node) {
		name = node.path("name").asText();
		
		skills.clear();
		for (JsonNode sk : node.path("skills")) {
			String nn = sk.path("name").asText();
			String tt = sk.path("text").asText();
			skills.add(new Skill(nn, tt));
		}
	}
	
	public ArrayList<String> getSkills() {
		ArrayList<String> ss = new ArrayList<String>();
		for (Skill sk : skills) {
			ss.add(sk.name);
		}
		return ss;
	}

	public static class Skill {
		public final String name;
		public final String text;

		public Skill(String name, String text) {
			this.name = name;
			this.text = text;
		}
	}
}

