package com.ironbeard.bezoar.battle;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;

public class Order {
	final int champ_id;
	final int skill_id;
	
	public Order(int champ_id, int skill_id) {
		this.champ_id = champ_id;
		this.skill_id = skill_id;
	}
	
	public JsonNode toJson() {
		JsonNodeFactory json = JsonNodeFactory.instance;
		ArrayNode node = json.arrayNode();
		node.add(json.numberNode(champ_id));
		node.add(json.numberNode(skill_id));
		return node;
	}
}
