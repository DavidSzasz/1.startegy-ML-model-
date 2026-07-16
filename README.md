# Algorithmic-trading-infrastructure
This project is has an execution program based on ML analyses or personal analysis strategies, and store all data derived from the analyses and trades in a relational databse

# Tools:
   - **Backend**
      - VS
      - C# .NET + ASP.NET Core
      - EF Core
      - Serilog

   - **Database (DB)**
      - dbdiagram.io
      - PostgreSQL
      - pgAdmin4

   - **Version Control**
      - Git + GitHub (Web + Desktop)

   - **Server & DevOps**
      - VPS
      - Docker
      - Docker Compose

   - **Security & environment management**
      - DotNetEnv

## Database Schema Rules
- **Migrations:** Always create migrations in the backend instead of managing them directly inside the RDBMS.
- **New Columns:** Must always allow `NULL` or have a small, primitive `DEFAULT` value.
- **Avoid `NOT NULL` on Existing Tables:** Never add a `NOT NULL` constraint without a default value, as it will break migrations for existing data.

# pipeline
   ## Execution process - (main)
   - **0.** ML model makes analysis from market data -> send it to the execution program
   - **1.** execution program stores:
      - trade parameters for execution - RAM
      - all data sent by the ML(signal history, features, ect) for audit & retraining - sql db
      - (If the ML model requires it, the executing program sends feedback.)
   - **2.** execution model:
      ## Signal Listener & State Manager (Checks capital and account resources, e.g., max open trades, and updates position state)
      --> 
      ## Order generator, manager (Determines order types and trade parameters, e.g., limit order, entry price)
      --> 
      ## Order Placement Process (API & SQL Synchronization):
         - **Staging State:** Creates a `PENDING` record in PostgreSQL to lock the system state and prevent race conditions before sending the request.
         - **Idempotency:** Attaches a unique execution key to the outbound request. If a network timeout occurs, the broker rejects any duplicate attempts.
         - **Logging:** Generates a detailed transaction log via Serilog capturing exact order parameters upon sending.
         - **Response-Driven Broker Sync:** Upon receiving the broker's **Response**, the system dynamically updates the SQL state from `PENDING` to its final status (`FILLED`, `REJECTED`, etc.), ensuring the database reflects the true execution state.
         - **REST Rate Limiting & Reconnect Logic:** A dedicated middleware that intercepts all outbound calls to enforce exchange rate limits (preventing IP bans) and handles automatic reconnection strings if a socket drops.
      -->
      [Broker API]
      --> 
      [Status Polling Loop] --> [Signal Listener & State Manager]:
         - **Continuous Sync Push:** The Broker API constantly polls the exchange for status/position updates and **pushes** this real-time data back into the *Signal Listener & State Manager*. This ensures the local RAM state is instantly updated if changes happen outside the normal flow (e.g., an exchange-side Stop-Loss triggers).
            |
      Transaction Log / State Sync (REST protection):
         - **Feedback Loop:** Feeds the finalized transaction data back into the *Signal Listener & State Manager* to instantly update local RAM balance, total open trade count, and account state, protecting the system against over-allocation before the next signal arrives.

    
   ## Broker & Trade Error Handling Process - (sub-process)

   *This sub-process triggers automatically whenever the main execution loop encounters orders during active trades, API timeouts, connection drops, or server-side errors.*

   - **API Outage / De-sync Handling**
      - Triggers automatically during trade execution failures, API timeouts, or server-side errors.
      - **Action:** Re-synchronizes the local system state with the broker via a *full portfolio polling loop*.
      - **Database Update:** Instantly updates the PostgreSQL DB to match the true exchange state.

   - **Missing Order Fallback**
      - Activated if the Broker API returns an anomaly (e.g., an order vanishes or its status becomes untrackable).
      - Routes the system directly to the emergency validation loop to protect capital.

   - **Critical Error Handling / Kill Switch (Emergency Stop)**
      - Activated instantly upon persistent rate-limiting, unrecoverable data corruption, or missing order critical failures.
      - **Triggers Immediate Market Close:** Fires a bulk order close request via the REST API to flatten all active positions.
      - **Execution Lock:** Permanently locks the execution program, forcing it to ignore all upcoming ML analysis signals.
      - **User Notification:** Dispatches urgent alerts via Telegram/Email.
      - **Audit Logging:** Logs the full incident context and stack trace directly into the PostgreSQL DB via Serilog for post-mortem analysis.

   ---

   - **Status Sync (The Bridge)**
      - The entire error handling mechanism continuously syncs its status back to the primary *Broker API* component in the main execution model, ensuring absolute state consistency.

   ---
   
   - **Data Persistence (SQL Database Architecture)**
      - The central PostgreSQL database acts as the single source of truth for the entire system, persistent across both successful execution and error tracking. It structures and maintains:
         - **Staging States:** Current lifecycle tracking for active transactions (`PENDING`, `FILLED`).
         - **Detailed System Logs:** Multi-level system logs synced natively through Serilog.
         - **Account States:** Historical records of balance fluctuations and asset allocations.
         - **Order Histories:** Comprehensive tracking of all broker executions for audit trails and machine learning retraining.