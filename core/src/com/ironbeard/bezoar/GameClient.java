package com.ironbeard.bezoar;

import org.phoenixframework.channels.*;
import com.fasterxml.jackson.databind.JsonNode;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.Preferences;

public class GameClient {
	final String defaultURL = "ws://localhost:4000/socket/websocket";

	BezoarGame game;
	Socket  sock;
	Channel chan;

	public GameClient(BezoarGame game) {
		this.game = game;
		final GameClient self = this;

		Preferences prefs = Gdx.app.getPreferences("Bezoar");
		final String url  = prefs.getString("url", defaultURL);
		final String user = prefs.getString("user", "bob");
		
		try {
			sock = new Socket(url);
			sock.connect();
			
			chan = sock.chan("players:" + user, null);
			chan.join()
				.receive("ignore", new IMessageCallback() {
					@Override
					public void onMessage(Envelope envelope) {
						Gdx.app.log("GameClient", "Got IGNORE");
					}
				})
				.receive("ok", new IMessageCallback() {
					@Override
					public void onMessage(Envelope env) {
						self.onState(env);
					}
				});
			
			chan.on("msg", new IMessageCallback() {
				@Override
				public void onMessage(Envelope env) {
					self.onMessage(env);
				}
			});
		}
		catch (Exception ee) {
			Gdx.app.log("GameClient", "Error: " + ee.toString());
			throw new Error("Fatal");
		}
		
		Gdx.app.log("GameClient", "done with constructor");
	}

	public void onState(Envelope env) {
		Gdx.app.log("GameClient", "Got OK");
		JsonNode msg   = env.getPayload();
		final JsonNode state = msg.path("response").path("state");
	
		Gdx.app.postRunnable(new Runnable() {
			public void run() { 
				game.updateBattle(state);
			}
		});
	}
	
	public void onMessage(Envelope env) {
		Gdx.app.log("GameClient", "Message: " + env.toString());
	}
}