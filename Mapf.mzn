int: height;
int: width;
int: agents;
% Decision problem for now (does path exist in time <= 'time'?)
int: time;

set of int: AGENTS = 1..(agents);
set of int: TIME = 1..(time);

type Pos = var record(var 0..(width-1): x, var 0..(height-1): y);

% Start position of agents.
array[AGENTS] of Pos: start;
% Goal position of agents.
array[AGENTS] of Pos: goal;
% Position of agents at time.
array[AGENTS, TIME] of Pos: pos;
% Distance from agent to goal at time.
array[AGENTS, TIME] of var 0..(width*height): goalDistance;

function var int: manhattan(var Pos: pos1, var Pos: pos2) = abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y);

% Agents start at their respective starting position.
constraint forall (i in AGENTS) (manhattan(start[i], pos[i,1]) == 0);

% No two agents share the same position at the same time (they can move through each other for now).
constraint forall (t in TIME, i,j in AGENTS) (i == j \/ manhattan(pos[i,t], pos[j,t]) != 0);

% Agents can only move 1 step per time (no diagonals for now).
constraint forall (t in 2..time, i in AGENTS) (manhattan(pos[i,t-1], pos[i,t]) <= 1);

% Calculate distance to goal.
constraint forall (t in TIME, i in AGENTS) (goalDistance[i, t] = manhattan(pos[i,t], goal[i]));

constraint forall (i in AGENTS) (goalDistance[i, time] <= 0);

solve satisfy;

