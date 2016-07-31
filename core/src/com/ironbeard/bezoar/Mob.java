package com.ironbeard.bezoar;

import java.util.HashMap;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.scenes.scene2d.Actor;
import com.badlogic.gdx.scenes.scene2d.InputEvent;
import com.badlogic.gdx.scenes.scene2d.Touchable;
import com.badlogic.gdx.scenes.scene2d.ui.Label;
import com.badlogic.gdx.scenes.scene2d.ui.Skin;
import com.badlogic.gdx.scenes.scene2d.ui.Table;
import com.badlogic.gdx.scenes.scene2d.utils.ClickListener;

public class Mob extends Table {
	final String name;
	final String uuid;

	HashMap<String, Integer> props;

	private Skin skin;
	private Label nameLabel;
	private Label hpLabel;
	
	public Mob(final String name, final String uuid) {
		this.name = name;
		this.uuid = uuid;
		
		skin = FontLoader.getSkin("DroidSans", 25);
			
		nameLabel = new Label(name, skin);
		hpLabel   = new Label("HP: 10/10", skin);
			
		add(nameLabel);
		row();
		add(hpLabel);
			
		setSkin(skin);
		setBackground("default-rect");
		setTouchable(Touchable.enabled);
			
		addListener(new ClickListener() {
			@Override
			public void clicked(InputEvent event, float _x, float _y) {
				Gdx.app.log("Mob Clicked", name);
			}	
		});
	}
	
	public Actor actor() {
		return this;
	}
}
