package com.ironbeard.bezoar;

import com.badlogic.gdx.Game;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;

public class BezoarGame extends Game {
	SpriteBatch batch;
	
	@Override
	public void create () {
		showLogin();
	}

	@Override
	public void render () {
		super.render();
	}
	
	@Override
	public void dispose () {
	}
	
	public void showLogin() {
		this.setScreen(new LoginScreen(this));
	}
	
	public void showBattle() {
		this.setScreen(new BattleScreen(this));
	}
}
