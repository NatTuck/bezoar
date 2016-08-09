package com.ironbeard.bezoar;

import java.io.IOException;
import java.util.ArrayList;

import org.phoenixframework.channels.*;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.ironbeard.bezoar.battle.Order;
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
		//final String user = prefs.getString("user", "bob");
		final int user = prefs.getInteger("user", 43);
		
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
						Gdx.app.log("GameClient", "Connected to server.");
					}
				});
			
			chan.on("begin", new IMessageCallback() {
				@Override
				public void onMessage(Envelope env) {
					self.onBegin(env);
				}
			});
		}
		catch (Exception ee) {
			Gdx.app.log("GameClient", "Error: " + ee.toString());
			throw new Error("Fatal");
		}
	}

	public void onBegin(Envelope env) {
		Gdx.app.log("GameClient", "Got Begin");
		final JsonNode bb = env.getPayload();
		
		Gdx.app.postRunnable(new Runnable() {
			public void run() { 
				game.updateBattle(bb);
			}
		});
	}
	
	public void sendOrders(ArrayList<Order> ords) {
		Gdx.app.log("GameClient", "Sending orders: " + ords.toString());
		
		JsonNodeFactory json = JsonNodeFactory.instance;
		
		ArrayNode node = json.arrayNode();
		for (Order oo : ords) {
			node.add(oo.toJson());
		}
	
		try {
			chan.push("orders", node);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
