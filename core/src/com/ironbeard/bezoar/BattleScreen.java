package com.ironbeard.bezoar;

import java.util.ArrayList;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.Screen;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.scenes.scene2d.Actor;
import com.badlogic.gdx.scenes.scene2d.InputEvent;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.scenes.scene2d.Touchable;
import com.badlogic.gdx.scenes.scene2d.ui.Cell;
import com.badlogic.gdx.scenes.scene2d.ui.Label;
import com.badlogic.gdx.scenes.scene2d.ui.Skin;
import com.badlogic.gdx.scenes.scene2d.ui.Table;
import com.badlogic.gdx.scenes.scene2d.ui.TextButton;
import com.badlogic.gdx.scenes.scene2d.utils.ChangeListener;
import com.badlogic.gdx.scenes.scene2d.utils.ClickListener;

import com.ironbeard.bezoar.battle.Battle;
import com.ironbeard.bezoar.battle.Mob;

public class BattleScreen implements Screen {
	BezoarGame game;
	
	Stage stage;
	Table table;
	Skin  skin;

	ArrayList<MobView> team0;
	ArrayList<MobView> team1;
	ArrayList<Cell<Actor>> skillSlots;
	
	Label statusLabel;

	public BattleScreen(final BezoarGame game) {
		this.game = game;
	
		skin = FontLoader.getSkin("DroidSans", 32);
		
		stage = new Stage();
		
		table = new Table();
		table.setFillParent(true);
		stage.addActor(table);
		
		table.setDebug(true);
	
		skillSlots = new ArrayList<Cell<Actor>>();
		
		team0 = new ArrayList<MobView>();
		for (int ii = 0; ii < 4; ++ii) {
			team0.add(new MobView(true));
		}

		team1 = new ArrayList<MobView>();
		for (int ii = 0; ii < 4; ++ii) {
			team1.add(new MobView(false));
		}
		
		statusLabel = new Label("", skin);
		
		table.add(team0.get(2)).fill().expand();
		table.add(team0.get(0)).fill().expand();
		table.add(statusLabel).fill().expand();
		table.add(team1.get(0)).fill().expand();
		table.add(team1.get(2)).fill().expand();
		table.row();
		table.add(team0.get(3)).fill().expand();
		table.add(team0.get(1)).fill().expand();
		table.add(new Label("", skin)).fill().expand();
		table.add(team1.get(3)).fill().expand();
		table.add(team1.get(1)).fill().expand();
		table.row();
		for (int ii = 0; ii < 3; ++ii) {
			@SuppressWarnings("unchecked")
			Cell<Actor> slot = table.add().uniform().fill().expandX();
			skillSlots.add(slot);
		}
		table.add(new Label("", skin)).uniform().fill().expandX();
		table.add(new TextButton("Back", skin)).uniform().fill().expandX();
	}
	
	@Override
	public void show() {
		Gdx.input.setInputProcessor(stage);
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

	public void update(Battle bb) {
		int ii;
			
		ii = 0;
		for (Mob mm : bb.team0) {
			team0.get(ii).update(mm);
			ii++;
		}
			
		ii = 0;
		for (Mob mm : bb.team1) {
			team1.get(ii).update(mm);
			ii++;
		}
	}
	
	public class SkillView extends TextButton {
		MobView mv;
		
		public SkillView(MobView mv, Mob.Skill sk) {
			super("", skin);

			this.mv = mv;
			setText(sk.name);
			
			final SkillView self = this;
			addListener(new ChangeListener() {
				@Override
				public void changed(ChangeEvent event, Actor actor) {
					self.clicked();
				}
			});
		}
		
		public void clicked() {
			Gdx.app.log("SkillView", "Clicked: " + getText());
		}
	}
	
	public class MobView extends Table {
		Skin skin;
		
		Label name;
		Label health;
		Label status;
		Label cmd;
		
		ArrayList<Mob.Skill> skills;
		
		public MobView(boolean canClick) {
			skin   = FontLoader.getSkin("DroidSans", 25);
			name   = new Label("...", skin);
			health = new Label("...", skin);
			status = new Label("...", skin);
			cmd    = new Label("...", skin);
			skills = new ArrayList<Mob.Skill>();

			add(name);
			row();
			add(health);
			row();
			add(status);
			row();
			add(cmd);

			setSkin(skin);
			setBackground("default-rect");
			setTouchable(Touchable.enabled);

			if (canClick) {
				final MobView self = this;
				addListener(new ClickListener() {
					@Override
					public void clicked(InputEvent event, float _x, float _y) {
						self.clicked();
					}
				});
			}
		}
		
		public void update(Mob mm) {
			name.setText(mm.name);
			health.setText("HP: " + mm.hp + "/" + mm.maxHp);
			status.setText(mm.status);
			cmd.setText(mm.cmd);
		
			skills.clear();
			for (Mob.Skill sk : mm.skills) {
				skills.add(sk);
			}
		}
		
		public void clicked() {
			for (int ii = 0; ii < skills.size(); ++ii) {
				Cell<Actor> slot = BattleScreen.this.skillSlots.get(ii);
				slot.setActor(new SkillView(this, skills.get(ii)));
			}
		}
	}
}
