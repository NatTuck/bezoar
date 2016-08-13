package com.ironbeard.bezoar;

import java.util.ArrayList;
import java.util.HashMap;

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
import com.badlogic.gdx.utils.Align;
import com.ironbeard.bezoar.battle.Battle;
import com.ironbeard.bezoar.battle.Champ;
import com.ironbeard.bezoar.battle.Event;
import com.ironbeard.bezoar.battle.Order;
import com.ironbeard.bezoar.battle.Posn;

public class BattleScreen implements Screen {
	BezoarGame game;
	
	Stage stage;
	Table table;
	Skin  skin;
	
	HashMap<Posn, Cell<Actor>> cells;
	HashMap<Posn, ChampView>   champs;
	ArrayList<Order>           orders;
	
	ArrayList<EventBall>       balls;
	
	public BattleScreen(final BezoarGame game) {
		this.game = game;
		
		cells  = new HashMap<Posn, Cell<Actor>>();
		champs = new HashMap<Posn, ChampView>();
		orders = new ArrayList<Order>();
		balls  = new ArrayList<EventBall>();
	
		skin = FontLoader.getSkin("DroidSans", 32);
		
		stage = new Stage();
		
		table = new Table();
		table.setFillParent(true);
		stage.addActor(table);
		
		table.setDebug(true);
	
		Actor placeholder = new Actor();
		for (int yy = 0; yy < 4; ++yy) {
			for (int xx = 0; xx < 5; ++xx) {
				Cell<Actor> cc = table.add(placeholder);
				cc.uniform().expand().fill();
				cells.put(new Posn(yy, xx), cc);
			}
			if(yy < 3) {
				table.row();
			}
		}
		
		for (int yy = 0; yy < 2; ++yy) {
			for (int xx = 0; xx < 4; ++xx) {
				int cx = xx < 2 ? xx : xx + 1;
				
				ChampView cv = new ChampView(xx < 2);
				champs.put(new Posn(yy, xx), cv);
				
				Cell<Actor> cc = cells.get(new Posn(yy, cx));
				cc.setActor(cv);
			}
		}

		for (int xx = 0; xx < 3; ++xx) {
			Cell<Actor> cc = cells.get(new Posn(2, xx));
			cc.setActor(new TextButton("...", skin));
		}
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
		for (int yy = 0; yy < 2; yy++) {
			for (int xx = 0; xx < 4; xx++) {
				Posn  pp = new Posn(yy, xx);
				Champ cc = bb.champs.get(pp);
				champs.get(pp).update(cc);
			}
		}
		
		if (bb.events.size() > 0) {
			balls.clear();
			for (Event ev : bb.events) {
				ChampView s_cv = find_champ(ev.source_id);
				ChampView t_cv = find_champ(ev.target_id);
				
				float x0 = s_cv.getX(Align.center);
				float y0 = s_cv.getY(Align.center);
				float x1 = t_cv.getX(Align.center);
				float y1 = t_cv.getY(Align.center);
				
				EventBall ball = new EventBall(x0, y0, x1, y1);
				balls.add(ball);
				stage.addActor(ball);
			}
		}
	}
	
	public ChampView find_champ(int champ_id) {
		for (ChampView cv : champs.values()) {
			if (cv.champ.id == champ_id) {
				return cv;
			}
		}
		
		return null;
	}
	
	public class SkillView extends TextButton {
		ChampView   cv;
		Champ.Skill sk;
		
		public SkillView(ChampView cv, Champ.Skill sk) {
			super("", skin);

			this.cv = cv;
			this.sk = sk;
			setText(sk.name);
			
			final SkillView self = this;
			addListener(new ChangeListener() {
				@Override
				public void changed(ChangeEvent event, Actor actor) {
					self.clicked();
					self.setDisabled(true);
				}
			});
		}
		
		public void clicked() {
			cv.skillClicked(sk.id);
		}
	}
	
	public class ChampView extends Table {
		Skin skin;
		
		public Champ champ;
		
		Label name;
		Label health;
		Label status;
		Label cmd;
		
		ArrayList<Champ.Skill> skills;
		
		public ChampView(boolean canClick) {
			skin   = FontLoader.getSkin("DroidSans", 25);
			name   = new Label("...", skin);
			health = new Label("...", skin);
			status = new Label("...", skin);
			cmd    = new Label("...", skin);
			skills = new ArrayList<Champ.Skill>();

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
				final ChampView self = this;
				addListener(new ClickListener() {
					@Override
					public void clicked(InputEvent event, float _x, float _y) {
						self.clicked();
					}
				});
			}
		}
		
		public void update(Champ mm) {
			champ = mm;
			name.setText(mm.name);
			health.setText("HP: " + mm.hp + "/" + mm.maxHp);
			status.setText(mm.status);
			cmd.setText(mm.cmd);
		
			skills.clear();
			for (Champ.Skill sk : mm.skills) {
				skills.add(sk);
			}
		}
		
		public void clicked() {
			for (int ii = 0; ii < skills.size(); ++ii) {
				Champ.Skill sk = skills.get(ii);
				
				Cell<Actor> btnSlot = BattleScreen.this.cells.get(new Posn(2, ii));
				btnSlot.setActor(new SkillView(this, sk));
				
				Cell<Actor> lblSlot = BattleScreen.this.cells.get(new Posn(3, ii));
				lblSlot.setActor(new Label(sk.desc, skin));
			}
		}
		
		@SuppressWarnings("unchecked")
		public void skillClicked(int skill_id) {
			Order ord = new Order(champ.id, skill_id);
			orders = BattleScreen.this.orders;
			orders.add(ord);
			
			if (orders.size() == 2) {
				BattleScreen.this.game.sendOrders((ArrayList<Order>)orders.clone());
				orders.clear();
			}
		}
	}
}
