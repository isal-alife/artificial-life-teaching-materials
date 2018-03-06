enum ThingType {
    FOOD,WATER,TRAP
};

class Thing {
    /**
     * Things include "food", "water" and "traps".
     *
     */
    
    float x,y;
    float amount = 1.0;
    float radius = 2.5;
    ThingType type;
    
    Thing(ThingType ntype) {
	x = random(ARENA_WIDTH);
	y = random(ARENA_WIDTH);
	type = ntype;
    }

    Thing(float nx, float ny, ThingType ntype) {
	x = nx;
	y = ny;
	type = ntype;
    }

    void draw() {
	int alpha = (int)(180*amount);
	if (type == ThingType.FOOD) {
	    fill(60,200,60,alpha);    
	}
	else if (type == ThingType.WATER) {
	    fill(60,60,200,alpha);
	}
	else {
	    fill(200,60,60,alpha);
	}
	noStroke();
	ellipse(x,y,radius*2,radius*2);
    }

    void update() {
	if (amount < 0.0) {
	    amount = 1.0;
	    x = random(ARENA_WIDTH);
	    y = random(ARENA_WIDTH);
	}
    }
}


class Environment {
    Vector<Thing> foods = new Vector<Thing>();
    Vector<Thing> waters = new Vector<Thing>();
    Vector<Thing> traps = new Vector<Thing>();
    
    Environment() {
	for(int i=0;i<4;i++) {
	    foods.add(new Thing(ThingType.FOOD));
	    waters.add(new Thing(ThingType.WATER));
	    //traps.add(new Thing(ThingType.TRAP));
	}
	traps.add(new Thing(ThingType.TRAP));
	traps.add(new Thing(ThingType.TRAP));
    }

    void reset() {
	for(Thing t : foods) {
	    t.amount = -1.0;
	    t.update();
	}
	for(Thing t : waters) {
	    t.amount = -1.0;
	    t.update();
	}
	for(Thing t : traps) {
	    t.amount = -1.0;
	    t.update();
	}
    }
    
    void interactWithRobot(Robot r) {
	final float consumption_rate = 0.25; // percent of full thing per time unit
	final float fill_rate = 0.25; // percent of full battery per time unit
	stroke(0,0,0,0);
	
	for(Thing t : foods) {
	    if(dist(t.x,t.y,r.x,r.y) < t.radius) {
		t.amount -= consumption_rate*TIMESTEP;
		r.food_battery += fill_rate*TIMESTEP;

		// if in evolve mode, we are going to draw the Things
		// only when they are consumed
		if(mode==MODE_EVOLVE) {
		    pushStyle();
		    fill(0,255,0,64);
		    ellipse(t.x,t.y,t.radius*2,t.radius*2);
		    popStyle();
		}
	    }
	}
	for(Thing t : waters) {
	    if(dist(t.x,t.y,r.x,r.y) < t.radius) {
		t.amount -= consumption_rate*TIMESTEP;
		r.water_battery += fill_rate*TIMESTEP;

		if(mode==MODE_EVOLVE) {
		    pushStyle();
		    fill(0,0,255,128);
		    ellipse(t.x,t.y,t.radius*2,t.radius*2);
		    popStyle();
		}
	    }
	}
	for(Thing t : traps) {
	    if(dist(t.x,t.y,r.x,r.y) < t.radius) {
		r.food_battery = 0.0;
		r.water_battery = 0.0;		
		r.is_alive = false;
		if(mode==MODE_EVOLVE) {
		    pushStyle();
		    fill(255,0,0,128);
		    ellipse(t.x,t.y,t.radius*2,t.radius*2);
		    popStyle();
		    t.x = random(ARENA_WIDTH);
		    t.y = random(ARENA_WIDTH);
		}
	    }
	}		
    }
    
    void update() {
	for(Thing t : foods) {
	    t.update();
	}
	for(Thing t : waters) {
	    t.update();
	}
	for(Thing t : traps) {
	    t.update();
	}	
    }

    void draw() {
	pushMatrix();
	//scale((float)width/ARENA_WIDTH,(float)height/ARENA_WIDTH);

	for(Thing t : foods) {
	    t.draw();
	}
	for(Thing t : waters) {
	    t.draw();
	}
	for(Thing t : traps) {
	    t.draw();
	}
	popMatrix();	
    }
    
}


