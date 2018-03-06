class Mapping {
    final int N_POINTS = 4; // total number of control points
    public float[] xs = new float[N_POINTS];
    public float[] ys = new float[N_POINTS];

    Mapping() {
	this.randomise();
    }

    Mapping(Mapping copy_me) {
	for(int i=0;i<N_POINTS;i++) {
	    xs[i] = copy_me.xs[i];
	    ys[i] = copy_me.ys[i];
	}
    }

    void randomise() {
	for(int i=0;i<N_POINTS;i++) {
	    xs[i]=random(0,1);
	    ys[i]=random(-1,1);
	}
	xs[0] = 0.0;
	xs[N_POINTS-1] = 1.0;
    }

    void mutate() {
	final float MU_1 = 0.01;
	final float MU_2 = 0.02;
	for(int i=0;i<N_POINTS;i++) {
	    // MUTATION PART I
	    xs[i] += randomGaussian()*MU_1;
	    ys[i] += randomGaussian()*MU_1;

	    xs[i] = constrain(xs[i],0.0,1.0);
	    ys[i] = constrain(ys[i],-1.0,1.0);

	    // MUTATION PART II
	    if(random(1.0) < MU_2) {
		xs[i] = random(0.0,1.0);
		ys[i] = random(-1.0,1.0);
	    }
	}

	// ensure xs stay in ascending order
	for(int i=0;i<N_POINTS-1;i++) {
	    if(xs[i] > xs[i+1]) {
		float tmp = xs[i];
		xs[i] = xs[i+1];
		xs[i+1] = tmp;
	    }
	}
	xs[0] = 0.0;
	xs[N_POINTS-1] = 1.0;
    }

    float f(float x) {
	// given the piecemeal function described by xs and ys,
	// linearly interpolate to provide the value of that function
	// for any x between 0 and 1.
	x = min(1.0,x);
	for(int i=0;i<N_POINTS-1;i++) {
	    if(x <= xs[i+1]) {
		// x lies between xs[i] and xs[i+1]
		// linearly interpolate
		float output = lerp(ys[i],ys[i+1],x-xs[i]/(xs[i+1]-xs[i]));
		//println(x,output);
		return output;		
	    }
	}	
	println("Non-interporlatable input! ERROR.");
	println(x);
	exit();
	return 0.0;
    }

    void draw() {	
	for(int i=0;i<N_POINTS-1;i++) {
	    line(xs[i],ys[i],xs[i+1],ys[i+1]);
	}
    }
}

class EvolvableBrain {
    final int N_SENSES = 3;
    final int N_MOTORS = 2;
    Mapping [][]maps = new Mapping[N_SENSES][N_MOTORS];

    EvolvableBrain() {
	for(int i=0;i<N_SENSES;i++) {
	    for(int j=0;j<N_MOTORS;j++) {
		maps[i][j] = new Mapping();
	    }
	}
    }

    EvolvableBrain(EvolvableBrain copy_me) {
	for(int i=0;i<N_SENSES;i++) {
	    for(int j=0;j<N_MOTORS;j++) {
		maps[i][j] = new Mapping(copy_me.maps[i][j]);
	    }
	}
    }


    // creates a random set of parameters (for initialisation of GA)
    void randomise() {
	for(int i=0;i<N_SENSES;i++) {
	    for(int j=0;j<N_MOTORS;j++) {
		maps[i][j].randomise();
	    }
	}
    }

    EvolvableBrain imprint(EvolvableBrain loser) {
	float nGenes = this.maps[0][0].N_POINTS*3*2;
	EvolvableBrain copy = new EvolvableBrain(loser);
	for(int i=0;i<N_SENSES;i++) {
	    for(int j=0;j<N_MOTORS;j++) {
		if(random(1.0)<0.5) {
		    copy.maps[i][j] = new Mapping(this.maps[i][j]);
		}
		copy.maps[i][j].mutate();
	    }
	}
	return copy;
    }

    void iterate(Robot robot) {
	// update the robot with the appropriate motor output
	// (robot.lMotor and robot.rMotor).
	//
	// The sensory data is available in robot.sensorValues
	//
	// If we assume bilateral symmetry, then we can have the maps
	// set up in the following way.
	//
	// map[0][0] Is the food sensor to the ipsilateral motor.
	// map[0][1] Is the food sensor to the contralateral motor.
	// map[1][0] is the water sensor to the ipsilateral motor.
	// etc.

	float lm_accum=0.0;
	float rm_accum=0.0;
	for(int sensor_i=0;sensor_i<N_SENSES;sensor_i++) {
	    //ipsilateral sensors
	    float leftm_ipsi  = maps[sensor_i][0].f(robot.sensorValues[sensor_i][0]);
	    float rightm_ipsi = maps[sensor_i][0].f(robot.sensorValues[sensor_i][1]);
	    //contralateral sensors
	    float leftm_contra = maps[sensor_i][1].f(robot.sensorValues[sensor_i][1]);
	    float rightm_contra = maps[sensor_i][1].f(robot.sensorValues[sensor_i][0]);

	    lm_accum += leftm_ipsi + leftm_contra;
	    rm_accum += rightm_ipsi + rightm_contra;
	}
	robot.lMotor = lm_accum/6.0;
	robot.rMotor = rm_accum/6.0;
    }

    /// This generates one column of the lower left plot
    void drawGenome() {
	colorMode(HSB,1.0);
	strokeWeight(1.0);
	beginShape(LINES);
	int gene_i = 0;
	int TOTAL_N_GENES = N_SENSES*N_MOTORS*maps[0][0].N_POINTS;
	for(int i=0;i<N_SENSES;i++) {
	    for(int j=0;j<N_MOTORS;j++) {
		for(int p_i=0;p_i<maps[i][j].N_POINTS;p_i++) {
		    stroke((float)gene_i/TOTAL_N_GENES,1.0,1.0,0.9);
		    gene_i++;
		    vertex(0.0,100*(maps[i][j].xs[p_i]));
		    vertex(100.0,100*maps[i][j].xs[p_i]);
		    stroke(i/N_SENSES*255,
			   j/N_MOTORS*255,0.0,0.5);
		    vertex(0.0,100*(maps[i][j].ys[p_i]+1.0)/2.0);
		    vertex(100.0,100*(maps[i][j].ys[p_i]+1.0)/2.0);
		}
	    }
	}
	endShape();
    }

    void drawMaps() {
	colorMode(RGB,255);
	strokeWeight(0.025);
	final int [][]rgbs = {{60,255,60},
			      {60,120,255},
			      {255,60,60}};
	for(int i=0;i<N_SENSES;i++) {
	    stroke(rgbs[i][0],rgbs[i][1],rgbs[i][2],128);
	    for(int j=0;j<N_MOTORS;j++) {
		pushMatrix();
		scale(1.0/N_MOTORS,0.5/N_SENSES);
		translate(j,2*i+1);
		maps[i][j].draw();
		popMatrix();
	    }
	}
    }

}
