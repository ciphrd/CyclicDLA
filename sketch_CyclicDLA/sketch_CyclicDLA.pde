// @author ciphrd <https://instagram.com/ciphrd>
// @license MIT
//
// Cyclic Diffusion-Limited Aggregation
// https://ciphered.xyz/2020/07/21/cyclic-diffusion-limited-aggregation/
//
// In this variant of the DLA, the aggregate is subject to decay / blur over time, simulating respectively the 
// evaporation / diffusion of the aggregate. On the other hand, once a particle "hits" the aggregate and gets
// added to it, its position is randomly set to any position on the grid instead of the sides.
// These 2 additions allows for the cyclic generation of patterns
//



// SIMULATION RULES
int NB_PARTICLES = 10000;
int SIZE = 256;    // aggregation grid size (^2)
boolean BLUR = false;
float AGGREG_THRESHOLD = 0.25;  // the threshold above which the sum of neighbors must be for aggregation to happen
float AGGREG_DECAY = 0.95;
float AGGREG_PREVENT = 0.001;   // self cell threshold under which the aggregation can happen, Tl
float AGGREG_ADDITION = 1.0;    // how much is added to the aggregate on aggregation
boolean CIRCLE_DISTRIB = true;  // are the particles distributed within the circle or on the whole canvas


// the ratio between the aggregation grid size and the number of particles is important
Particle[] particles = new Particle[NB_PARTICLES];
float[] aggregation = new float[SIZE*SIZE];


int VIEW = 512;    // window size
float SIZE2 = (float) SIZE * .5;
float cell = (float) VIEW / SIZE;   // size of a cell
float RAD = 115;   // radius in which aggregation is possible


void setup () {
  surface.setSize(VIEW, VIEW); 
  
  // initialize the aggration area
  for (int x = 0; x < SIZE; x++) {
    for (int y = 0; y < SIZE; y++) {
      writeAggregation(y > SIZE2-1 && y < SIZE2+1 ? 1.0 : 0.0, x, y);
    }
  }
  
  // initialize the particles position
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle(); 
  }
}

void writeAggregation (float v, int x, int y) {
  aggregation[x+SIZE*y] = v; 
}

float getAggregation (int x, int y) {
  if (x < 0 || x >= SIZE || y < 0 || y >= SIZE) return 0;
  return aggregation[x+SIZE*y];
}

void drawAggregation () {
  for (int x = 0; x < SIZE; x++) {
    for (int y = 0; y < SIZE; y++) {
      fill(min(.5, getAggregation(x, y)) * 1.5 * 255);
      noStroke();
      rect(x*cell, y*cell, cell, cell);
    }
  }
}

// returns the sum of the neighbours arround a particle
float neighboursSum (int x, int y) {
  float s = 0.0;
  s+= getAggregation(x-1, y-1);
  s+= getAggregation(x, y-1);
  s+= getAggregation(x+1, y-1);
  s+= getAggregation(x+1, y);
  s+= getAggregation(x+1, y+1);
  s+= getAggregation(x, y+1);
  s+= getAggregation(x-1, y+1);
  s+= getAggregation(x-1, y);
  return s;
}

void draw () {
  // we update the particles position
  for (int i = 0; i < particles.length; i++) {
    particles[i].update(); 
    
    // the sum of the aggregates arround the particle
    float sum = neighboursSum(particles[i].x, particles[i].y);
    
    // distance to the center of the canvas
    float d = sqrt((float) (particles[i].x-SIZE2)*(particles[i].x-SIZE2) + (particles[i].y-SIZE2)*(particles[i].y-SIZE2));
    
    // are the conditions to add particle to the aggregate met ?
    if (sum > AGGREG_THRESHOLD && getAggregation(particles[i].x, particles[i].y) < AGGREG_PREVENT && d < RAD) {
      writeAggregation(AGGREG_ADDITION, particles[i].x, particles[i].y); 
      particles[i].randPos();
    }
  }
  
  for (int x = 0; x < SIZE; x++) {
    for (int y = 0; y < SIZE; y++) {
      if (BLUR) {
        float s = 0.0;
        s+= getAggregation(x-1, y-1) * 0.0625;
        s+= getAggregation(x, y-1) * .125;
        s+= getAggregation(x+1, y-1) * 0.0625;
        s+= getAggregation(x+1, y) * .125;
        s+= getAggregation(x+1, y+1) * .0625;
        s+= getAggregation(x, y+1) * .125;
        s+= getAggregation(x-1, y+1) * .0625;
        s+= getAggregation(x-1, y) * .125;
        s+= getAggregation(x, y) * .25;
        
        aggregation[x+y*SIZE] = s * AGGREG_DECAY;
      } else {
        aggregation[x+y*SIZE]*= AGGREG_DECAY;
      }
    }
  }
  
  
  drawAggregation();
  
  // draw particles
  /*
  for (int i = 0; i < particles.length; i++) {
    particles[i].draw(); 
  }
  */
}
