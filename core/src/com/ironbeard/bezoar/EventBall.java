package com.ironbeard.bezoar;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.g2d.Batch;
import com.badlogic.gdx.graphics.glutils.ShapeRenderer;
import com.badlogic.gdx.graphics.glutils.ShapeRenderer.ShapeType;
import com.badlogic.gdx.scenes.scene2d.Actor;

public class EventBall extends Actor {
	public final float x0;
	public final float y0;
	public final float x1;
	public final float y1;
	public final float speed;
	
	public float xx;
	public float yy;
	public boolean done;
	
	public ShapeRenderer sr;
	
	public EventBall(float x0, float y0, float x1, float y1) {
		this.x0 = x0;
		this.y0 = y0;
		this.x1 = x1;
		this.y1 = y1;
		this.speed = 50.0f;
		
		this.xx = x0;
		this.yy = y0;
		this.done = false;
		
		sr = new ShapeRenderer();
	}
	
	@Override
	public void act(float dt) {
		super.act(dt);

		Gdx.app.log("EventBall", "act");

		float dx = dt * speed * Math.signum(x1 - xx);
		float dy = dt * speed * Math.signum(y1 - yy);
	
		if (Math.abs(dx) >= Math.abs(x1 - xx) || Math.abs(dy) >= Math.abs(y1 - yy)) {
			this.xx = x1;
			this.yy = y1;
			this.done = true;
		}
		else {
			this.xx += dx;
			this.yy += dy;
		}
	}
	
	@Override
	public void draw(Batch bb, float alpha) {
		super.draw(bb, alpha);
		
		if (done) {
			return;
		}

		Gdx.app.log("EventBall", "draw " + xx + ", " + yy);
		
		sr.setProjectionMatrix(bb.getProjectionMatrix());
		sr.begin(ShapeType.Filled);
		sr.setColor(1, 0, 0, alpha);
		sr.circle(xx, yy, 30);
		sr.end();
	}
}
