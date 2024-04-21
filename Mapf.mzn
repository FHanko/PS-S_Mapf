int: height;
int: width;
int: agents;
% Decision problem for now (does path exist in time <= 'time'?)
int: time;

set of int: AGENTS = 1..(agents);
set of int: TIME = 1..(time);

% Start position of agents.
array[AGENTS] of 0..(height-1): ystart;
array[AGENTS] of 0..(width-1): xstart;

% Goal position of agents.
array[AGENTS] of 0..(height-1): ygoal;
array[AGENTS] of 0..(width-1): xgoal;

% Position of agents at time.
array[AGENTS, TIME] of var 0..(height-1): ypos;
array[AGENTS, TIME] of var 0..(width-1): xpos;

array[AGENTS, TIME] of var 0..(width*height): goalDistance;

function var int: manhattan(var int: x1, var int: y1,
                            var int: x2, var int: y2) = abs(x1 - x2) + abs(y1 - y2);

% Agents start at their xstart, ystart.
constraint forall (i in AGENTS) (manhattan(xstart[i], ystart[i], xpos[i,1], ypos[i,1]) == 0);

% No two agents share the same position at the same time (they can move through each other for now).
constraint forall (t in TIME, i,j in AGENTS) (i == j \/ manhattan(xpos[i,t], ypos[i,t], xpos[j,t], ypos[j,t]) != 0);

% Agents can only move 1 step per time (no diagonals for now).
constraint forall (t in 2..time, i in AGENTS) (manhattan(xpos[i,t-1], ypos[i,t-1], xpos[i,t], ypos[i,t]) <= 1);

% Calculate distance to goal.
constraint forall (t in TIME, i in AGENTS) (goalDistance[i, t] = manhattan(xpos[i,t], ypos[i,t], xgoal[i], ygoal[i]));

constraint forall (i in AGENTS) (goalDistance[i, time] <= 0);

solve satisfy;

