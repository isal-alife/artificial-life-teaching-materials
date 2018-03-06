// EVOLVE CONSTANTS AND VARIABLES
int generation=0;
int tournament=0;

static int TRIAL_LENGTH = 1500;
static int N_TRIALS = 1;
float[] fitnesses = new float[POP_SIZE];
// Vector<Float> meanFitnessHistory = new Vector<Float>();
// Vector<Float> peakFitnessHistory = new Vector<Float>();
static int HISTORY_SIZE = 500;
float[] meanFitnessHistory = new float[HISTORY_SIZE];
float[] peakFitnessHistory = new float[HISTORY_SIZE];

void iterateEvolve() {
    ///////////////////////////////////////////////////////////////////////////////////
    // EVOLUTIONARY ALGORITHM
    tournament++;

    // select parents
    int aID = int(random(0,POP_SIZE));
    int bID = int(random(0,POP_SIZE));
    while (aID == bID) {
	bID = int(random(0,POP_SIZE));
    }

    Robot a = new Robot();
    a.setBrain(evolvableBrains[aID]);
    a.setEnvironment(env);
    Robot b = new Robot();
    b.setBrain(evolvableBrains[bID]);
    b.setEnvironment(env);

    float aFitness = 0;
    float bFitness = 0;

    clearDrawingAreas(); // DRAWING CODE (YOU CAN IGNORE THIS LINE)

    for(int trialID =0; trialID < N_TRIALS; trialID ++) {
	env.reset();
	a.reset();
	b.reset();

	initDrawSpatial(); // DRAWING CODE (YOU CAN IGNORE THIS LINE)

	// Simulate a trial for two competitors, A and B
	for(int tIteration = 0; tIteration < TRIAL_LENGTH; tIteration++) {
	    // we simulate a and b simultaneously, for simplicity
	    // as they can not interact
	    if(a.is_alive) {
		a.calculateChange();
		a.update();
		aFitness += (a.food_battery+a.water_battery)/2.0/TRIAL_LENGTH;
	    }
	    if(b.is_alive) {
		b.calculateChange();
		b.update();
		bFitness += (b.food_battery+b.water_battery)/2.0/TRIAL_LENGTH;
	    }
	    env.update();

	    if(!a.is_alive && !b.is_alive) break;

	    /////////////////////////////////////////////////////
	    ////// DRAWING CODE (YOU CAN IGNORE THIS CODE)
	    //////
	    ////// This code stores various details of the robot's
	    ////// position etc., so they can be plotted later. Just
	    ////// ignore it! :)
	    if(a.is_alive) {
		a_xs[tIteration] = a.x;
		a_ys[tIteration] = a.y;
		a_fbs[tIteration] = a.food_battery;
		a_wbs[tIteration] = a.water_battery;

		a_lfss[tIteration] = a.sensorValues[0][0];
		a_lwss[tIteration] = a.sensorValues[1][0];
		a_ltss[tIteration] = a.sensorValues[2][0];
		a_rfss[tIteration] = a.sensorValues[0][1];
		a_rwss[tIteration] = a.sensorValues[1][1];
		a_rtss[tIteration] = a.sensorValues[2][1];
	    }
	    if(b.is_alive) {
		b_xs[tIteration] = b.x;
		b_ys[tIteration] = b.y;
	    }
	    ////// END DRAWING CODE
	    /////////////////////////////////////////////////////	    
	}

	closeDrawSpatial(trialID); // DRAWING CODE (YOU CAN IGNORE THIS LINE)
    }
    // Normalise fitness to be between 0 and 1
    aFitness /= N_TRIALS;
    bFitness /= N_TRIALS;
	
    fitnesses[aID] = aFitness;
    fitnesses[bID] = bFitness;
	
    // Identify winner / loser..
    int winnerID = bID;
    int loserID = aID;
    if(fitnesses[aID] > fitnesses[bID]) {
	winnerID = aID;
	loserID = bID;
    }

    // what does the imprint function do here?
    evolvableBrains[loserID] = evolvableBrains[winnerID].imprint(evolvableBrains[loserID]);

    gatherStatisticsForPlotting(); // DRAWING CODE (YOU CAN IGNORE THIS)
    plotBarChart();                // DRAWING CODE (YOU CAN IGNORE THIS)
    plotFitness();                 // DRAWING CODE (YOU CAN IGNORE THIS)
}
