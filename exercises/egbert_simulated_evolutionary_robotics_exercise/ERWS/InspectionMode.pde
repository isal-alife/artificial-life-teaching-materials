
void iterateInspection() {
    boolean shouldReset = true;
    for(int i=0;i<n_to_inspect;i++) {
	if(robots[i].is_alive) {
	    shouldReset = false;
	}
    }
        
    if(shouldReset || iteration > TRIAL_LENGTH) {
	iteration = 0;
	env.reset();
	for(int i=0;i<n_to_inspect;i++) {
	    robots[i].reset();
	}
    }
    
    iteration++;	      
    if(iteration % 25 == 0) {
	print("iteration: " + iteration + "\n");
    }	    
    for(int i=0;i<n_to_inspect;i++) {
	robots[i].calculateChange();
    }
    for(int i=0;i<n_to_inspect;i++) {
	robots[i].update();
    }
    env.update();	
    
    background(32,32,32,32);
    pushMatrix();
    resetMatrix();
    scale(ASPECT_RATIO_X,1.0); // aspect ratio
    scale((float)width/ARENA_WIDTH,(float)height/ARENA_WIDTH);
    scale(0.5,0.5);
    translate(ARENA_WIDTH/2,ARENA_WIDTH/2);

    
    for(int i=0;i<n_to_inspect;i++) {	
    	robots[i].draw();
    }

    env.draw();
    popMatrix();
}
