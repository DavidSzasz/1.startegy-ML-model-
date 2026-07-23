# ML Model

## Improtant

### Backtest
* ML model predictions are evaluated on historical dataset versions using historical optimization variants; results are validated against metrics like WFE and Sharpe ratio.

### Demo
* Requirements: Model must have a winning `optimization` validated in walk forward.
* Real-time paper trading execution where the selected ML optimization variant generates live predictions on incoming market stream without risking real capital.

### Live
* Requirement: Optimization variant worked and demonstrated stability/profitability in `Demo` session.
* Trades and signals are generated during real-time `Live` trading, driven directly by the most profitable, battle-tested ML optimization variants using real money.

# Personal analysis strategies

## Improtant

### outsider data + outsider analysis(`tradingView`) or insider data + outsider analysis(`python project`)
* outsider data + outsider analysis in database = in `pers_optimization_run` the `dataset_version_id` is null
* insider data + outsider analysis in database = in `pers_optimization_run` the `dataset_version_id` is an FK

### Backtest
* Trades are created from optimization variants witch are running on the dataset versions, they are stored as `optimization trades`. 

### Demo
* Requirements: Strategy must have a winning `optimization` validated in Backtest.
* Trades are generated during real-time `Demo` trading, they are created based on the most profitable optimization variants, they are stored as `Demo trades`. 

### Live
* requirement: optimization variant worked in `Demo` session.
* Trades are generated during real-time `Live` trading, they are created based on the most profitable optimization variants, they are stored as `Live trades`.   