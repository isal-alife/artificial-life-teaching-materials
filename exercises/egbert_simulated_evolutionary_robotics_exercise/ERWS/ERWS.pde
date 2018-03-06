import java.util.*;

//////// CONSTANTS
static float ASPECT_RATIO_X = 2.0/3.0;
static int TEXT_SIZE = 20;
static float ARENA_WIDTH  = 40;
static float TIMESTEP = 0.04;
int iteration = 0; // this increases by one every time step

static int POP_SIZE = 30;
Environment env = new Environment();
Robot[] robots = new Robot[POP_SIZE];
EvolvableBrain[] evolvableBrains = new EvolvableBrain[POP_SIZE];

// MODE SETTINGS
static int MODE_SHOW_POPULATION = 0;
static int MODE_EVOLVE = 1;
static int MODE_INSPECTION = 2;
int mode = MODE_EVOLVE;

// GUI CONTROL VARIABLES
int n_to_inspect=0;
static boolean show_sensors = false;

void setup() {
    // Called once at the beginning
    size(1200, 800); // window size
    textSize(TEXT_SIZE);

    //smooth(); // commenting this out may make things run faster on an older cpu

    // Initialise evolveable population of brains.
    for(int i=0;i<POP_SIZE;i++) {
	evolvableBrains[i] = new EvolvableBrain();
	evolvableBrains[i].randomise();
    }

    // Initialise robots
    for(int i=0;i<POP_SIZE;i++) {
	Robot r = new Robot();
	robots[i] = r;

	robots[i].setBrain(evolvableBrains[i]);
	robots[i].setEnvironment(env);
    }

}

void keyTyped() {
    if(key == '1') {
	frameRate(1);
    }
    if(key == '2') {
	frameRate(10);
    }
    if(key == '3') {
	frameRate(30);
    }
    if(key == '4') {
	frameRate(40);
    }
    if(key == '5') {
	frameRate(10000);
    }
    
    if(key == 'e' || key == 'E') {
	mode = MODE_EVOLVE;
    }
    if(key == 'R') {
	// Randomise the population of brains.
	for(int i=0;i<POP_SIZE;i++) {
	    evolvableBrains[i].randomise();
	}
    }
    if(key == 's' || key == 'S') {
	show_sensors = !show_sensors;
    }
    if(key == 'b' || key == 'B') {
	int fittest_i = 0;
	float highest_fitness = 0.0;
	for(int i=0;i<POP_SIZE;i++) {
	    if (fitnesses[i] > highest_fitness) {
		highest_fitness = fitnesses[i];
		fittest_i = i;
	    }
	}	    
	mode = MODE_INSPECTION;
	iteration = TRIAL_LENGTH*100; // make it reset everything
	robots[0].setBrain(evolvableBrains[fittest_i]);
	robots[0].reset();
	n_to_inspect = 1;
    }
    if(key == 'p' || key == 'P') {
	mode = MODE_INSPECTION;
	iteration = TRIAL_LENGTH*100; // make it reset everything

	for(int i=0;i<POP_SIZE;i++) {
	    robots[i].setBrain(evolvableBrains[i]);
	    robots[i].reset();
	}
	n_to_inspect = POP_SIZE;
	
    }
    if(key == 'q' || key == 'Q') {
	exitSimulation();
    }
}

void draw() {
    if(mode == MODE_EVOLVE) {
	iterateEvolve();
    }
    else if(mode == MODE_SHOW_POPULATION ||
	    mode == MODE_INSPECTION) {
	iterateInspection();
    }
}


void exitSimulation() {
    System.exit(0);
}
