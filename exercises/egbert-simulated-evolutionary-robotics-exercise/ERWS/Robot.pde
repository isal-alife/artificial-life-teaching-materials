
class Robot {
    final float radius = 1;
    final float beta = 3.14159 / 4;    // sensor angle offset from forward
    float x,y,a;                       // robot position and heading
    float food_battery, water_battery; //battery levels
    float lMotor,rMotor;               // motors
    boolean is_alive = true;     

    float[][] sensorValues = new float[3][2]; // row = sensortype, col = left vs right sensor

    float r,g,b,alpha;
    
    EvolvableBrain brain;
    Environment env;
    
    Robot() {
	x=random(0,ARENA_WIDTH);
	y=random(0,ARENA_WIDTH);
	a=random(0,2.0*3.14159);

	food_battery = 1.0;
	water_battery = 1.0;
	
	lMotor=random(0,1);
	rMotor=random(0,1);
	r = random(64,192);
	g = random(64,192);
	b = random(64,192);
	alpha = 128;	
    }     

    void reset() {
	// initialise agent locations
	this.x = random(ARENA_WIDTH);
	this.y = random(ARENA_WIDTH);

	this.food_battery = 0.75;
	this.water_battery = 0.75;
	this.is_alive = true;
    }
    
    void setBrain(EvolvableBrain b) {
	brain = b;
    }

    void setEnvironment(Environment e) {
	env = e;
    }
    
    void update() {
	brain.iterate(this);	
	final double maxSpeed = 10.0;

	if(is_alive) {
	    x += TIMESTEP * cos(a)*(lMotor+rMotor) * maxSpeed;
	    y += TIMESTEP * sin(a)*(lMotor+rMotor) * maxSpeed;
	    a += TIMESTEP * maxSpeed * (lMotor-rMotor)/(2.0*radius);	

	    // ///// BEGIN WRAP
	    // if(x > ARENA_WIDTH) x = x-ARENA_WIDTH;
	    // if(y > ARENA_WIDTH) y = y-ARENA_WIDTH;
	    // if(x < 0) x = x + ARENA_WIDTH;
	    // if(y < 0) y = y + ARENA_WIDTH;
	    // ///// END WRAP

	    env.interactWithRobot(this);
	    
	    food_battery = constrain(food_battery-0.04*TIMESTEP,0.0,1.0);
	    water_battery = constrain(water_battery-0.04*TIMESTEP,0.0,1.0);
	}
	
	if(food_battery == 0.0 || water_battery == 0.0) {
	    is_alive = false;
	    food_battery = 0.0;
	    water_battery = 0.0;
	}

    }

    float sense(PVector sv, Thing t) {
	float k = 1.0;
	PVector sensor_to_thing = new PVector(t.x-(x+sv.x*radius),
					      t.y-(y+sv.y*radius));
	// linear falloff with distance
	float impact = (ARENA_WIDTH-sensor_to_thing.mag())/ARENA_WIDTH;
	float attenuation = sv.dot(sensor_to_thing.normalize());
	attenuation *= attenuation*attenuation;
	if (attenuation < 0.0) {
	    attenuation = 0.0;
	}
	return impact * attenuation;
    }
    
    void calculateChange() {
	// calculate sensors		
	Vector<PVector> sensorVectors = new Vector<PVector>();
	sensorVectors.add(PVector.fromAngle(a-beta)); // left sensor
	sensorVectors.add(PVector.fromAngle(a+beta)); // right sensor

	float raw_sensor_value;
	for(int i=0; i < sensorVectors.size(); i++) {
	    // FOOD
	    raw_sensor_value = 0.0;
	    for(Thing t : env.foods) {
		float s = sense(sensorVectors.get(i),t);
		if (s > raw_sensor_value) {
		    raw_sensor_value = s;
		}
	    }
	    sensorValues[0][i] = raw_sensor_value;

	    // WATER
	    raw_sensor_value = 0.0;
	    for(Thing t : env.waters) {
		float s = sense(sensorVectors.get(i),t);
		if (s > raw_sensor_value) {
		    raw_sensor_value = s;
		}
	    }
	    sensorValues[1][i] = raw_sensor_value;

	    // TRAP
	    raw_sensor_value = 0.0;
	    for(Thing t : env.traps) {
		float s = sense(sensorVectors.get(i),t);
		if (s > raw_sensor_value) {
		    raw_sensor_value += s;
		}
	    }
	    sensorValues[2][i] = raw_sensor_value;
	}	
    }
    

    // Used to draw the robots in the Show view
    void draw() {	
	colorMode(RGB, 255);
	//draw body
	alpha = 127;
	if(this.is_alive) {
	    alpha = 255;
	}
	fill(64,64,64,alpha);
	strokeWeight(0.125);
	stroke(255,255,255,alpha);
	float gx = x;
	float gy = y;
	ellipse(gx,gy,
		radius*2,
		radius*2);
	float hx = cos(a)*radius;
	float hy = sin(a)*radius;

	// which way is forward line
	line(gx,gy,gx+hx,gy+hy);

    	//////////////////////////////
    	// BATTERY LEVELS
    	float r = 1.95*radius;
    	// food battery
    	fill(60,255,60,alpha);
    	arc(gx, gy, r, r, a+PI, a+PI*(0.01+food_battery)+PI);
    	// water battery
    	fill(60,60,255,alpha);
    	arc(gx, gy, r, r, PI+a-PI*(0.01+water_battery), PI+a);

    	/////////////////////////////////
    	// sensor lines

    	/// FOOD SENSOR
    	float delta = beta*0.3;
    	float alpha = 200;
    	strokeWeight(0.1);
    	PVector lsVector = PVector.fromAngle(a-(beta+delta));
    	stroke(60,255*sensorValues[0][0],60,alpha);
    	line(gx+0.75*lsVector.x,
    	     gy+0.75*lsVector.y,
    	     gx+1.5*lsVector.x,
    	     gy+1.5*lsVector.y);
    	PVector rsVector = PVector.fromAngle(a+(beta+delta));
    	stroke(60,255*sensorValues[0][1],60,alpha);
    	line(gx+0.75*rsVector.x,
    	     gy+0.75*rsVector.y,
    	     gx+1.5*rsVector.x,
    	     gy+1.5*rsVector.y);

    	// WATER SENSOR
    	lsVector = PVector.fromAngle(a-(beta));
    	stroke(60,60,255*sensorValues[1][0],alpha);
    	line(gx+0.75*lsVector.x,
    	     gy+0.75*lsVector.y,
    	     gx+1.5*lsVector.x,
    	     gy+1.5*lsVector.y);
    	rsVector = PVector.fromAngle(a+(beta));
    	stroke(0,0,255*sensorValues[1][1],alpha);
    	line(gx+0.75*rsVector.x,
    	     gy+0.75*rsVector.y,
    	     gx+1.5*rsVector.x,
    	     gy+1.5*rsVector.y);

    	// TRAP SENSOR
    	lsVector = PVector.fromAngle(a-(beta-delta));
    	stroke(255*sensorValues[2][0],60,60,alpha);
    	line(gx+0.75*lsVector.x,
    	     gy+0.75*lsVector.y,
    	     gx+1.5*lsVector.x,
    	     gy+1.5*lsVector.y);
    	rsVector = PVector.fromAngle(a+(beta-delta));
    	stroke(255*sensorValues[2][1],60,60,alpha);
    	line(gx+0.75*rsVector.x,
    	     gy+0.75*rsVector.y,
    	     gx+1.5*rsVector.x,
    	     gy+1.5*rsVector.y);
    }
    
}

