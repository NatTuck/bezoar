package com.ironbeard.bezoar.battle;

import com.fasterxml.jackson.databind.JsonNode;

public class Posn {
	public final int yy;
	public final int xx;
	
	public Posn(int yy, int xx) {
		this.yy = yy;
		this.xx = xx;
	}
	
	public Posn(JsonNode node) {
		this.yy = node.get(0).asInt();
		this.xx = node.get(1).asInt();
	}
	
	@Override
	public boolean equals(Object obj) {
		Posn p1 = (Posn) obj;
		return (p1.xx == xx) && (p1.yy == yy);
	}
	
	@Override
	public int hashCode() {
		return yy << 8 + (xx * yy) + xx;
	}
}
