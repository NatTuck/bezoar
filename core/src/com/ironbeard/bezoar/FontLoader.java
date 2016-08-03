package com.ironbeard.bezoar;

import java.util.HashMap;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.g2d.BitmapFont;
import com.badlogic.gdx.graphics.g2d.TextureAtlas;
import com.badlogic.gdx.graphics.g2d.freetype.FreeTypeFontGenerator;
import com.badlogic.gdx.graphics.g2d.freetype.FreeTypeFontGenerator.FreeTypeFontParameter;
import com.badlogic.gdx.scenes.scene2d.ui.Skin;

public class FontLoader {
	static HashMap<String, BitmapFont> fonts = new HashMap<String, BitmapFont>();
	static HashMap<String, Skin>       skins = new HashMap<String, Skin>();

	public static BitmapFont load(String name, int size) {
		String key = name + "-" + size;
		
		if (!fonts.containsKey(key)) {
			FreeTypeFontGenerator gen = new FreeTypeFontGenerator(Gdx.files.internal("fonts/" + name + ".ttf"));
			FreeTypeFontParameter cfg = new FreeTypeFontParameter();
			cfg.size = size;
			
			BitmapFont font = gen.generateFont(cfg);
			fonts.put(key, font);
			gen.dispose();
		}

		return fonts.get(key);
	}
	
	public static Skin getSkin(String name, int size) {
		String key = name + "-" + size;

		if (!skins.containsKey(key)) {
			Skin skin = new Skin();
			skin.addRegions(new TextureAtlas(Gdx.files.internal("uiskin.atlas")));
			skin.add("default-font", FontLoader.load(name, size), BitmapFont.class);
			skin.load(Gdx.files.internal("uiskin.json"));
			
			skins.put(key, skin);
		}
		
		return skins.get(key);
	}
}
