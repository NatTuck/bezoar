package com.ironbeard.bezoar.battle;

import java.util.ArrayList;

import com.fasterxml.jackson.databind.JsonNode;

public class Champ {
	public int id;
	public String name;
	public int hp;
	public int maxHp;
	public String status;
	public String cmd;
	public Posn posn;

	public ArrayList<Skill> skills;

	private void init() {
		id = -1;
		name = "";
		hp = 0;
		maxHp = 0;
		status = "";
		cmd = "";
		
		skills = new ArrayList<Skill>();
	}
	
	public Champ() {
		init();
	}
	
	public Champ(JsonNode node) {
		init();
		loadJson(node);
	}

	public void loadJson(JsonNode node) {
		id   = node.path("id").asInt();
		name = node.path("name").asText();
		posn = new Posn(node.path("posn"));
		
		skills.clear();
		for (JsonNode sk : node.path("skills")) {
			int    id = sk.path("id").asInt();
			String nn = sk.path("name").asText();
			String dd = sk.path("desc").asText();
			skills.add(new Skill(id, nn, dd));
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
		public final int id;
		public final String name;
		public final String desc;

		public Skill(int id, String name, String desc) {
			this.id   = id;
			this.name = name;
			this.desc = desc;
		}
	}
}

