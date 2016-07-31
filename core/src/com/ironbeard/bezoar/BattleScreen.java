package com.ironbeard.bezoar;

import java.util.ArrayList;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.Screen;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.scenes.scene2d.ui.Button;
import com.badlogic.gdx.scenes.scene2d.ui.Label;
import com.badlogic.gdx.scenes.scene2d.ui.Skin;
import com.badlogic.gdx.scenes.scene2d.ui.Table;
import com.badlogic.gdx.scenes.scene2d.ui.TextButton;

public class BattleScreen implements Screen {
	BezoarGame game;
	
	Stage stage;
	Table table;
	Skin  skin;
	
	ArrayList<Mob> mobs;
	ArrayList<Button> cmdBtns;

	public BattleScreen(final BezoarGame game) {
		this.game = game;
	
		skin = FontLoader.getSkin("DroidSans", 32);
		
		stage = new Stage();
		Gdx.input.setInputProcessor(stage);
		
		table = new Table();
		table.setFillParent(true);
		stage.addActor(table);
		
		table.setDebug(true);
	
	
		mobs = new ArrayList<Mob>();
		for (int ii = 0; ii < 8; ++ii) {
			mobs.add(new Mob("Bob #" + ii, "uuid" + ii));
		}
		
		cmdBtns = new ArrayList<Button>();
		for (int ii = 0; ii < 3; ++ii) {
			cmdBtns.add(new TextButton("", skin));
		}
	
		
		table.add(mobs.get(0).actor()).fill().expand();
		table.add(mobs.get(1).actor()).fill().expand();
		table.add(new Label("", skin)).fill().expand();
		table.add(mobs.get(4).actor()).fill().expand();
		table.add(mobs.get(5).actor()).fill().expand();
		table.row();
		table.add(mobs.get(2).actor()).fill().expand();
		table.add(mobs.get(3).actor()).fill().expand();
		table.add(new Label("", skin)).fill().expand();
		table.add(mobs.get(6).actor()).fill().expand();
		table.add(mobs.get(7).actor()).fill().expand();
		table.row();
		for (int ii = 0; ii < 3; ++ii) {
			table.add(cmdBtns.get(ii)).uniform().fill().expandX();
		}
		table.add(new Label("", skin)).uniform().fill().expandX();
		table.add(new TextButton("Back", skin)).uniform().fill().expandX();
	}
	
	@Override
	public void show() {
		// TODO Auto-generated method stub
	}

	@Override
	public void render(float delta) {
		Gdx.gl.glClearColor(0, 0, 0.2f, 1);
		Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
		//camera.update();
		
		stage.act(Gdx.graphics.getDeltaTime());
		stage.draw();
	}

	@Override
	public void resize(int width, int height) {
		stage.getViewport().update(width, height, true);
	}

	@Override
	public void pause() {
		// TODO Auto-generated method stub

	}

	@Override
	public void resume() {
		// TODO Auto-generated method stub

	}

	@Override
	public void hide() {
		// TODO Auto-generated method stub

	}

	@Override
	public void dispose() {
		// TODO Auto-generated method stub

	}

}
