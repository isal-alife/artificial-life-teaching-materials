float []a_xs = new float[TRIAL_LENGTH];
float []a_ys = new float[TRIAL_LENGTH];

// track battery levels
float []a_fbs = new float[TRIAL_LENGTH];
float []a_wbs = new float[TRIAL_LENGTH];

// track sensor levels
float []a_lfss = new float[TRIAL_LENGTH]; //left food
float []a_lwss = new float[TRIAL_LENGTH];
float []a_ltss = new float[TRIAL_LENGTH];
float []a_rfss = new float[TRIAL_LENGTH]; //right food
float []a_rwss = new float[TRIAL_LENGTH]; 
float []a_rtss = new float[TRIAL_LENGTH];
float []b_xs = new float[TRIAL_LENGTH];
float []b_ys = new float[TRIAL_LENGTH];		


void plotSensorHistory(float []ys, float pos,
		       float r, float g, float b) {
    pushMatrix();
    resetMatrix();
    scale(ASPECT_RATIO_X,1.0);
    translate(2*width/2+pos*width/4,
    	      height*2/4);
    scale(width/4,height/4);
    
    colorMode(RGB,255);
    noFill();

    stroke(r,g,b,255);
    strokeWeight(0.01);
    beginShape(LINES);
    for(int i=0;i<TRIAL_LENGTH;i++) {
    	vertex((float)i/TRIAL_LENGTH,
    	       1.0-ys[i]);
    	//vertex((float)i/TRIAL_LENGTH,0.5);
    }
    endShape();
    popMatrix();
}

void plotBatteryLevelHistory(float []a_fbs, float []a_wbs) {
    pushMatrix();
    resetMatrix();
    scale(ASPECT_RATIO_X,1.0);
    translate(2*width/2,height*3/4);
    scale(width/2,height/4);

    colorMode(RGB,255);
    // draw food_battery for A
    stroke(60,255,60,255);
    strokeWeight(0.005);
    beginShape(LINES);
    for(int i=0;i<TRIAL_LENGTH;i++) {
	vertex((float)i/TRIAL_LENGTH,
	       1.0-a_fbs[i]);
    }
    endShape();

    // draw water_battery for A
    stroke(60,60,255,255);
    strokeWeight(0.01);
    beginShape(LINES);
    for(int i=0;i<TRIAL_LENGTH;i++) {
	vertex((float)i/TRIAL_LENGTH,
	       1.0-a_wbs[i]);
    }
    endShape();
    popMatrix();

}


void plotFitness() {
    pushMatrix();
    resetMatrix();
    scale(ASPECT_RATIO_X,1.0);
    translate(width/2,0);//height/2);
    scale(2*width/2,height/2);
    

    // plot mean and peak fitness over time
    colorMode(HSB,1.0);
    noStroke();
    fill(0.5,0,0.1);
    rect(0,0,1.0,1.0);
    noFill();
  
    // peak fitness
    stroke(0.5,1.0,1.0); // cyan
    strokeWeight(0.005);

    beginShape();
    for(int i=0;i<HISTORY_SIZE;i++) {
    	float x = (float)i / HISTORY_SIZE;
    	float y = peakFitnessHistory[i];
    	vertex(x,1.0-y);
    }
    endShape();

    // mean fitness
    stroke(0.75,1.0,1.0); // purple
    beginShape();
    for(int i=0;i<HISTORY_SIZE;i++) {
    	float x = (float)i / HISTORY_SIZE;
    	float y = meanFitnessHistory[i];
    	vertex(x,1.0-y);
    }
    endShape();
    popMatrix();

    // plot genotypes (lower left)
    pushMatrix();
    scale(ASPECT_RATIO_X,1.0);
    translate(0,height/2);
    fill(0,0,0);
    rect(0,0,width/2,height/2);
    scale(width/200,height/200);
    scale(1.0/(POP_SIZE+1),1);
    for(int i=0;i<POP_SIZE;i++) {
	evolvableBrains[i].drawGenome();
	translate(100,0);
    }
    popMatrix();

    if(!show_sensors) {
	// plot genotypes (lower left)
	pushMatrix();
	scale(ASPECT_RATIO_X,1.0);
	translate(2*width/2,height/2);
	fill(0,0,0);
	rect(0,0,width/2,height/2);
	scale(width/2,height/2);
	// scale(width/200,height/200);
	// fill(0,0,0);
	// rect(0,0,1,1);

	for(int i=0;i<POP_SIZE;i++) {
	    evolvableBrains[i].drawMaps();
	}
	popMatrix();
	fill(255,255,255,255);
	text("ipsi. food",2*width/3,height/2+TEXT_SIZE);
	text("contra. food",2.5*width/3,height/2+TEXT_SIZE);
	text("ipsi. water",2*width/3,height/6+height/2+TEXT_SIZE);
	text("contra. water",2.5*width/3,height/6+height/2+TEXT_SIZE);
	text("ipsi. trap",2*width/3,height/6+height/6+height/2+TEXT_SIZE);
	text("contra. trap",2.5*width/3,height/6+height/6+height/2+TEXT_SIZE);
    //text("generation: "+tournament/POP_SIZE,5,TEXT_SIZE*2.05);

    }
    stroke(0,0,0,255);
    strokeWeight(0.00001);

}

void plotBarChart() {
    pushMatrix();
    resetMatrix();
    scale(ASPECT_RATIO_X,1.0);
    strokeWeight(2.0);
    colorMode(HSB,1.0);
    stroke(0,0,1.0);
    float minX = 0;
    float minY = 0;
    float maxX = width/2;
    float maxY = height/2;
    fill(0,0,0);
    rect(minX,minY,maxX-minX,maxY-minY);
    for(int i=0;i<POP_SIZE;i++) {
	fill(1.0-0.01*i,0.01*i,1.0);
	float colWidth = (maxX - minX) / (POP_SIZE+1);
	float fitness = (float)fitnesses[i];
	//	    rect((float)i*colWidth,1.0 - fitness*(maxY-minY),width,maxY);
	float x1 = minX + (float)i*colWidth;
	float x2 = x1 + colWidth;
	float y1 = maxY;
	float y2 = maxY - fitness*(maxY-minY);
	quad(x1,y1,x2,y1,x2,y2,x1,y2);
    }
    text("tournament: "+tournament,5,TEXT_SIZE);
    text("generation: "+tournament/POP_SIZE,5,TEXT_SIZE*2.05);

    popMatrix();
}

void clearSensorChartArea() {
    pushMatrix();
    scale(ASPECT_RATIO_X,1.0);
    translate(width/2,2.0*height/6);
    scale(width/1,height/1);
    // scale(width/4/ARENA_WIDTH,height/2/ARENA_WIDTH);
    colorMode(RGB,255);
    fill(0,0,0,255);
    rect(0,0,1,1);
    popMatrix();
}

void clearBatteryChartArea() {
    pushMatrix();
    scale(ASPECT_RATIO_X,1.0);
    translate(width/2,height/6);
    scale(width/1,height/1);
    // scale(width/4/ARENA_WIDTH,height/2/ARENA_WIDTH);
    colorMode(RGB,255);
    fill(0,0,0,1);
    rect(0,0,1,1);
    popMatrix();
}

void clearTrajectoryArea() {
    pushMatrix();
    scale(ASPECT_RATIO_X,1.0);
    translate(width/2,height/2);
    scale(width/200,height/200);
    //scale(width/4/ARENA_WIDTH,height/2/ARENA_WIDTH);
    fill(0,0,0);
    rect(0,0,100,100);
    popMatrix();
	
}

void clearDrawingAreas() {
    clearBatteryChartArea();
    clearSensorChartArea();
    clearTrajectoryArea();
}


void initDrawSpatial() {
    strokeWeight(0.1);
    pushMatrix();
    scale(ASPECT_RATIO_X,1.0);
    translate(width/2,height/2);
    scale(width/2/ARENA_WIDTH,height/2/ARENA_WIDTH);
    a_xs = new float[TRIAL_LENGTH];
    a_ys = new float[TRIAL_LENGTH];
    
    // track battery levels
    a_fbs = new float[TRIAL_LENGTH];
    a_wbs = new float[TRIAL_LENGTH];

    // track sensor levels
    a_lfss = new float[TRIAL_LENGTH]; //left food
    a_lwss = new float[TRIAL_LENGTH];
    a_ltss = new float[TRIAL_LENGTH];
    a_rfss = new float[TRIAL_LENGTH]; //right food
    a_rwss = new float[TRIAL_LENGTH]; 
    a_rtss = new float[TRIAL_LENGTH];
    b_xs = new float[TRIAL_LENGTH];
    b_ys = new float[TRIAL_LENGTH];		

}

void closeDrawSpatial(int trialID) {
    if(show_sensors) {
	// values, position, r, g, b
	plotSensorHistory(a_lfss,0,0,255,0);
	plotSensorHistory(a_lwss,0,0,0,255);
	plotSensorHistory(a_ltss,0,255,0,0);
	plotSensorHistory(a_rfss,1,0,255,0);
	plotSensorHistory(a_rwss,1,0,0,255);
	plotSensorHistory(a_rtss,1,255,0,0);
	plotBatteryLevelHistory(a_fbs,a_wbs);
    }
    pushStyle();
    noFill();
    beginShape(POINTS);
    colorMode(HSB,255);
    stroke(0,255-255*((float)trialID / N_TRIALS),220);
    strokeWeight(0.2);
    for(int i=0;i<TRIAL_LENGTH;i++) {
	vertex(a_xs[i],a_ys[i]);
    }
    stroke(200,255-255*((float)trialID / N_TRIALS),220);
    for(int i=0;i<TRIAL_LENGTH;i++) {
	vertex(b_xs[i],b_ys[i]);
    }
    endShape();
    popStyle();
    popMatrix();

}


void gatherStatisticsForPlotting() {
    float sum = 0;
    int fittestID = 0;
    float maxFitness = 0;
    for(int i=0;i<POP_SIZE;i++) {
	sum += fitnesses[i];
	if(fitnesses[i] > maxFitness) {
	    maxFitness = fitnesses[i];
	    fittestID = i;
	}
    }

    int h_index = tournament % HISTORY_SIZE;
    peakFitnessHistory[h_index] = maxFitness;
    meanFitnessHistory[h_index] = sum / POP_SIZE;
}
