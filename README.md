# ATS - Automated Train Scheduling
ATS is a mod for factorio that adds train scanners and train schedulers to schedule trains automatically via circuit network. 

## Dependencies
[figsoda/pactorio](https://github.com/figsoda/pactorio)

## Build
Run `pactorio` under this directory. 

## Usage
ATS adds two new buildings to the game, both can be unlocked through technology. 

A **train scanner** has an input end on the left and an output end on the right. The accepeted input signals and corresponding output signals are shown in the table below. 

input | output
:-: | :-:
signal-T = -1 | signal-T = train id, iterates through all trains
signal-T > 0 | no output, select the train with given id
signal-locomotive = -1 | all fuel in locomotives
signal-locomotive = -2 | signal-locomotive = number of locomotives
signal-locomotive = -3 | includes the previous two
signal-cargo-wagon = -1 | all contents in cargo wagons
signal-cargo-wagon = -2 | signal-cargo-wagon = number of cargo wagons
signal-cargo-wagon = -3 | includes the previous two
signal-fluid-wagon = -1 | all fluids in in fluid wagon
signal-fluid-wagon = -2 | signal-fluid-wagon = number of fluid wagons
signal-fluid-wagon = -3 | includes the previous two
signal-train-station = -2 | signal-train-station = number of stations in the schedule
signal-train-station > 0 | signal-train-station = station id of the station with given index
signal-current-station = -1 | signal-current-station = station id of the current station
signal-current-station = -2 | signal-current-station = index of the current station in the schedule
signal-temporary = -1 | signal-temporary = 1 if the train station outputing is temporary
signal-temporary = -2 | signal-temporary = 2 if the current station outputing is temporary
signal-temporary = -3 | includes the previous two

A **train scheduler** has an input end. The accepted input signals and corresponding effects areshown in the table below. 

input | effect
:-: | :-:
signal-T > 0 | select the train with given id
signal-add-station = -1 | add a station to the end of the schedule
signal-add-station > 0 | insert a station to given index in the schedule
signal-train-station > 0 | add the station with given id
signal-temporary != 0 | add a temporary station
signal-compare-type < 0 | the wait conditions are compared with `and`
signal-compare-type >= 0 | the wait conditions are compared with `or`
signal-time-passed > 0 | add time passed to wait conditions with given number of ticks
signal-inactivity > 0 | add inactivity to wait conditions with given number of ticks
signal-cargo < 0 | add empty cargo to wait conditions
signal-cargo > 0 | add full cargo to wait conditions
signal-circuit-condition != 0 | add circuit condition signal-P > 0 to wait conditions
signal-passenger < 0 | add passenger not present to wait conditions
signal-passenger > 0 | add passenger present to wait conditions
signal-go-to-station > 0 | go to the station with given index
