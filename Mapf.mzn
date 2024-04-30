int: height;
set of int: ZH = 0..(height-1);
int: width;
set of int: ZW = 0..(width-1);
int: agents;
set of int: AGENTS = 1..(agents);
% Decision problem (does path exist in time <= 'time'?)
int: time;
set of int: TIME = 1..(time);

type Pos = var record(var ZW: x, var ZH: y);

% Start position of agents.
array[AGENTS] of Pos: start;
% Goal position of agents.
array[AGENTS] of Pos: goal;
% Position of agents at time.
array[AGENTS, TIME] of var Pos: pos;
% Distance from agent to goal at time.
array[AGENTS, TIME] of var 0..(width*height): goalDistance;
% Flag for each time: Are all goals reached?
array[TIME] of var 0..1: goalsReached;
var 0..time: makespan;

function var int: manhattan(var Pos: pos1, var Pos: pos2) = abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y);

% Agents start at their respective starting position.
constraint forall (i in AGENTS) (manhattan(start[i], pos[i,1]) == 0);
% Setting the endpoint at max time actual improves performance (atleast when time >>> makespan).
constraint forall (i in AGENTS) (manhattan(goal[i], pos[i,time]) == 0);

% No two agents share the same position at the same time (they can move through each other for now).
constraint forall (t in TIME, i,j in AGENTS) (i == j \/ manhattan(pos[i,t], pos[j,t]) != 0);

% Agents can only move 1 step per time (no diagonals for now).
constraint forall (t in 1..(time-1), i in AGENTS) (manhattan(pos[i,t], pos[i,t+1]) <= 1);

% Calculate distance to goal.
constraint forall (t in TIME, i in AGENTS) (goalDistance[i, t] == manhattan(pos[i,t], goal[i]));

% Set goalsReached flag
constraint forall (t in TIME) (forall (i in AGENTS) (goalDistance[i, t] == 0) <-> goalsReached[t] == 0);
constraint forall (t in TIME) (forall (i in AGENTS) (goalDistance[i, t] != 0) <-> goalsReached[t] == 1);

% Calcualting the makespan like this improves performance over previous attempt.
constraint makespan == sum(goalsReached)+1;
solve minimize makespan;

output [
        (if y==0 /\ x==0 /\ t==1 then "\nAgent: \(a)\n" else "" endif) ++
        (if (x: x,y: y) == fix(pos[a, t]) then "*" elseif (x: x,y: y) in fix(pos[a, 1..t-1]) then "-" else "." endif) ++ 
        (if x==(width-1) then "   " else " " endif) ++
        (if t==fix(makespan) /\ x==(width-1) then "\n" else "" endif)
        | a in AGENTS, y in ZH, t in 1..fix(makespan), x in ZW 
       ]
