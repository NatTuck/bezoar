package com.ironbeard.bezoar;

import com.badlogic.gdx.Game;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.fasterxml.jackson.databind.JsonNode;
import com.ironbeard.bezoar.battle.Battle;

public class BezoarGame extends Game {
	SpriteBatch batch;
	GameClient  client;
	
	public LoginScreen  loginScreen;
	public BattleScreen battleScreen;
	public Battle       battle;
	
	@Override
	public void create () {
		loginScreen = new LoginScreen(this);
		battleScreen = new BattleScreen(this);

		battle = new Battle();
		client = new GameClient(this);
		
		showLogin();
	}

	@Override
	public void render () {
		super.render();
	}
	
	@Override
	public void dispose () {
		super.dispose();
	}
	
	public void showLogin() {
		this.setScreen(loginScreen);
	}
	
	public void showBattle() {
		this.setScreen(battleScreen);
	}
	
	public void updateBattle(JsonNode state) {
		battle.loadJson(state);
		battleScreen.update(battle);
	}
}
